# Maintainer / development notes

Internal notes for terminal-agent-picker. For user-facing docs see README.md; for the contribution flow see CONTRIBUTING.md.

## Wiring

- Installed by sourcing `terminal-agent-picker.zsh` from `~/.zshrc` or `terminal-agent-picker.bash` from `~/.bashrc`.
- Both entrypoints are tiny guards that set `NTAP_ROOT` and source `terminal-agent-picker.sh`.
- `terminal-agent-picker.sh` is the hand-authored shared source. There is no generator, no JSON source file, and no build step.
- Runtime per-directory memory file: `${XDG_CONFIG_HOME:-~/.config}/ntap/last` (tab-separated `PWD<TAB>key<TAB>model<TAB>reasoning<TAB>perm`). Override with `$NTAP_LAST_FILE`.

## Verified vs best-effort agents

- Verified locally (installed + `--help` checked): claude, codex, gemini, opencode, cursor (`cursor-agent`).
- Best-effort from research, not locally verified: amp, droid, aider, goose, crush, copilot, qwen, openhands, rovodev, kilo, continue, gptme, kiro, pi, hermes, plandex, openhands-mini. All auto-hidden unless installed; verify flags before relying on the long tail. This is disclosed to users in the README "Verified vs best-effort agents" section.

## Gotchas

- `grok` resolves to a cmux stub (`/Applications/cmux.app/Contents/Resources/bin/grok`) that errors "grok not found in PATH", it is NOT the real xAI Grok Build CLI. Deliberately NOT added as an agent.
- cmux ships shim binaries in its bin dir (`claude`, `grok`, ...); `command -v` can false-positive. `claude`'s shim works; `grok`'s does not.
- Gemini sunsets 2026-06-18 and migrates to Antigravity `agy`. Handled via multi-bin detection (`NTAP_gemini_bins=$'gemini agy'`). If `agy`'s flags differ from Gemini's, edit the Gemini template.
- `cursor-agent --help` prints nothing in a non-tty, so its `--model` / `--mode` flags are best-effort.
- Claude Fable 5 became generally available on 2026-06-09. Claude Code exposes it through the `fable` alias. It is first in the Claude model menu, but the default remains `sonnet` to avoid surprise cost/latency.
- Bare-TUI agents (droid, crush, goose, etc.) do not expose model/reasoning/permission menus here; their settings come from the agent's own config.

## Design decisions

- Per-directory last-used memory (relaunch) + session-resume (`r`): claude `--continue`, codex `resume --last`, opencode `--continue`, gemini `--resume latest`. cursor has no resume.
- Real back navigation (`b`); prompts worded so Enter reads as confirm.
- Multi-binary detection (gemini|agy, cursor-agent|agent) with launch-binary swap.
- Permission tiers (installed agents) = 3 consistent, color-coded tiers: **Plan / Standard / Auto** (default standard; green/amber/red). Auto means true yolo/bypass.
- Prompt mode: default `NTAP_MODE=terminal-native` keeps terse hints for terminal users. `NTAP_MODE=terminal-new` changes hints to word-first language for new users, but both modes accept both native tokens and words.
- Session system prompt: supported agents get a prompt step after permission. Default is no custom prompt. Claude Code exposes only replacement by default: option 2 asks for a normal file path and passes it with `--system-prompt-file` for that launched session only. The shared engine still supports `*_sysprompt_append_file` for custom agents. The prompt is intentionally not stored in per-directory memory.

## Hardening

- Entry files return before parsing shell-specific syntax under the wrong shell.
- Memory is structured (PWD/key/model/reasoning/perm), never a raw command. Relaunch reconstructs through `_ntap_build`.
- Session prompt memory is separate from per-directory memory and cleared when the picker exits. Inline prompt temp files are removed after the launched agent exits; user-provided file paths are never removed.
- `_ntap_save` is append-only (atomic `>>`, one line < PIPE_BUF), so concurrent terminal opens do not clobber each other; `_ntap_last` takes the last matching `$PWD`.
- EOF guards on every `read` (`|| return 0` / quit) so a closed stdin can never silently relaunch a stored command.
- Numeric menu input is length-bounded before arithmetic compare, so a long paste cannot leak shell arithmetic warnings into the menu.

## Roadmap

- curl|sh installer on a release tag.
- Per-directory memory could move to one small file per `$PWD` (hashed name) to drop the append-log + trim entirely.
- Optional fzf/gum UI once auto-detected, with numbered-menu fallback.
- Directory browser: a name that collides with a reserved key (`b`, `back`, `q`, `quit`, `d`, `new`, `..`, `up`, `parent`, `~`, `home`) is reachable by index but not by typing.
- Startup latency: `command -v` fan-out over ~22 agents, fine on local SSD, slower on NFS/SSH homes; could cache resolved bins keyed on a `$PATH` hash.

## Workflow

Edit `terminal-agent-picker.sh` -> run syntax and smoke checks -> commit. The CI check (`.github/workflows/build-check.yml`) validates bash/zsh syntax, launch smokes, wrong-shell no-ops, and installer round-trips.
