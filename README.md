# terminal-agent-picker

A tiny bash/zsh startup picker for people who use AI coding agents.

Open a new terminal, pick an agent, its model, reasoning/effort, and permission, and it launches. Just press Enter for a plain shell. Your last choice per directory is remembered. Agents that aren't installed are hidden.

It also gives LLM-driven workflows a short, repeatable way to open worker terminals with the right model, reasoning level, and permission mode without spelling out long command lines each time.

The repo is intentionally small and easy to audit. Use the bundled agents as a starting point, then customize `terminal-agent-picker.sh` for your own tools, model defaults, permission tiers, and prompt habits.

```
  ❯ New terminal  ~/projects
  number to choose an agent · enter = plain shell

    1  Claude Code
    2  OpenAI Codex CLI
    3  Google Gemini CLI
    4  opencode (SST)
    5  Cursor CLI

    p  pick a directory      d  new directory
  ❯ 2

  ❯ OpenAI Codex CLI  ›  model
  number to choose · enter = default · b back · q shell

    1  GPT-5.5 (strongest overall)  (default · enter)
    2  GPT-5.4 (balanced flagship)
    3  GPT-5.4-mini (fast/cheap, caps at high)
    4  GPT-5.3 Codex Spark (near-instant, Pro only)
  ❯ 1

  ❯ OpenAI Codex CLI  ›  reasoning / effort
  number to choose · enter = default · b back · q shell

    1  Minimal
    2  Low
    3  Medium (default)
    4  High  (default · enter)
    5  xHigh (gpt-5.5/gpt-5.4 only)
  ❯

  ❯ OpenAI Codex CLI  ›  permission
  number to choose · enter = default · b back · q shell

    1  Plan: read & explore, no writes
    2  Standard: edits here, asks before risky  (default · enter)
    3  Auto: runs autonomously, no prompts
  ❯

  launching  codex -m gpt-5.5 -c model_reasoning_effort="high" -s workspace-write -a on-request
```

Only installed agents appear, so the numbers depend on what you have. Each menu shows a `❯` breadcrumb (which agent, which step) and the current directory, a dimmed one-line hint, accent-colored keys, and a clear default marker; permission tiers are color-coded by risk (green safe, red risky).

Navigation is forgiving: a number selects, `b`/`back` goes back a layer, `q`/`shell` drops to a plain shell, Enter takes the default, and an unrecognized key just re-prompts, so a typo never strands you. Folder prompts support Tab completion. Reasoning and permission steps appear only for agents that take them. If you've launched in this directory before, the first prompt is a fast path, `Enter = relaunch · r/resume · c/choose · s/shell`, so you re-enter your environment in one keystroke. If no supported agent is installed, the picker prints nothing and you get a normal shell.

For Claude Code, the picker asks about a session-only system prompt after the permission step. Press Enter for no custom prompt, or choose `Replace system prompt for this session` and type a normal prompt file path such as `local-prompts/Fable5prompt.md`. Replacement applies only to the agent session you are launching. It also checks the picker's own `local-prompts/`, so a prompt saved there can be selected with just `Fable5prompt.md`.

## Why a sourced snippet, not a terminal command

Some terminals and terminal wrappers expect the configured command to be the user's actual shell or agent process. Pointing a terminal command at a picker script can break session creation or close the tab as soon as the script exits. This runs inside bash or zsh interactive startup instead, so any terminal that starts a supported interactive shell stays a normal shell and the menu just prints inside it.

## Requirements

- bash or zsh
- any terminal that starts an interactive bash or zsh

If your normal shell is something else, configure the terminal/profile where you want the picker to start bash or zsh. You do not have to change your system default shell; the picker only runs when a supported shell reads its source line.

## Install

```sh
git clone https://github.com/swissyai/terminal-agent-picker.git ~/.config/terminal-agent-picker
~/.config/terminal-agent-picker/install.sh
```

The installer auto-detects bash vs zsh from `$SHELL`. You can also be explicit:

```sh
~/.config/terminal-agent-picker/install.sh --shell zsh
~/.config/terminal-agent-picker/install.sh --shell bash
```

Or add the source line yourself:

```sh
# zsh
echo 'source ~/.config/terminal-agent-picker/terminal-agent-picker.zsh' >> ~/.zshrc

# bash
echo 'source ~/.config/terminal-agent-picker/terminal-agent-picker.bash' >> ~/.bashrc
```

Open a new terminal. Existing terminals are unaffected. `install.sh --uninstall` removes the picker lines from bash and zsh startup files. Use `--shell bash` or `--shell zsh` with uninstall to narrow it.

If no menu appears, either the terminal did not start an interactive supported shell, the matching source line was not read, or no supported agent binary is on `PATH`.

## Update

If you installed to the README path, update with:

```sh
git -C ~/.config/terminal-agent-picker pull --ff-only
```

Open a new terminal after updating. If you customized `terminal-agent-picker.sh`, commit or stash your local changes before pulling.

## Verified vs best-effort agents

Five agents are verified locally (installed, binary and flags checked): **Claude Code, OpenAI Codex CLI, Google Gemini CLI, opencode, Cursor**. Cursor's binary is verified; its `--model`/`--mode` flags are best-effort, since `cursor-agent --help` prints nothing in a non-tty.

The rest (amp, droid, aider, goose, crush, copilot, qwen, openhands, rovodev, kilo, continue, gptme, kiro, pi, hermes, plandex, openhands-mini) are research-derived and **not locally verified**. They're hidden unless installed; if you rely on one, confirm its flags first. A few launch as a bare TUI and read model/permission from their own config rather than from this menu (goose, droid, crush).

## Permissions and safety

Installed agents use three consistent, color-coded tiers (safest first; **Standard** is the default):

- **Plan** (green): read and explore, no writes.
- **Standard** (amber): edits the workspace, asks before risky/destructive actions. The default.
- **Auto** (red): full autonomy (YOLO), approves everything, no prompts. Maps to each agent's bypass flag (Claude `--dangerously-skip-permissions`, Codex `--dangerously-bypass-approvals-and-sandbox`, Gemini `--approval-mode yolo`, opencode `--dangerously-skip-permissions`).

Auto runs an agent with no approval prompts. Use it only in a sandbox or a trusted repo. The default is always the safe/standard tier, never Auto; the launch line printed before the agent starts always shows the exact command, so you can see what you're about to run. One exception to the "Standard asks first" framing: Amp has no ask-first mode and is autonomous by design; its menu label says so.

## Session system prompts

After the permission menu, supported agents show a system prompt step. Press Enter for no custom prompt, or choose replacement mode to pass a file with `--system-prompt-file`. It asks for a normal file path, checks the current folder, the picker install folder, and the picker's ignored `local-prompts/` folder. The older `@path/to/file` form still works.

Currently this is wired for Claude Code. Replacement mode uses `--system-prompt-file` and replaces the system prompt for that launched session only. It is useful for experiments, but can change Claude Code's normal tool behavior. Session prompts are not saved in per-directory memory and are not reused by a future terminal unless you set them again.

The picker support is generic. Any agent can expose a system-prompt step if its CLI has a real prompt-file flag; add `*_sysprompt_replace_file` or `*_sysprompt_append_file` to that agent entry. The bundled defaults only enable it where the flag has been verified.

Local scratch prompts can live under `local-prompts/`, which is gitignored. Example flow:

```text
1   # Claude Code
1   # Fable 5
Enter   # High effort default
Enter   # Standard permission default
2   # Replace system prompt for this session
Fable5prompt.md
```

## Customize

`terminal-agent-picker.sh` is the source of truth. There is no generator and no build step.

You are encouraged to make this your own. Delete agents you do not use, add local ones, change defaults, and tune permission labels to match how your team actually works.

### Prompt style

The default is `terminal-native`: compact terminal tokens like `p`, `d`, `..`, `~`, `b`, and `q`.

For wordier prompts, set this before the source line in `~/.zshrc` or `~/.bashrc`:

```sh
export NTAP_MODE=terminal-new
```

Both styles accept both forms. For example, `..`, `up`, and `parent` all move to the folder that contains the current one; `~` and `home` both go to your home folder; `d` and `new` both create a folder; and `q` and `shell` both drop to a normal shell.

### Add or edit an agent

```sh
NTAP_ORDER+=(myagent)
NTAP_myagent_label=$'My Agent'
NTAP_myagent_bins=$'myagent'
NTAP_myagent_tmpl=$'myagent --model {model} {permission}'
NTAP_myagent_models=$'fast\tFast\nstrong\tStrong'
NTAP_myagent_perms=$'standard\t--ask\tStandard: asks first\tmedium\nauto\t--yes\tAuto: no prompts\thigh'
NTAP_myagent_sysprompt_replace_file=$'--system-prompt-file'
NTAP_myagent_defm=$'strong'
NTAP_myagent_defr=$''
NTAP_myagent_defp=$'standard'
```

- **`NTAP_ORDER`**: display order. Only agents whose binaries are installed are shown.
- **`*_bins`**: what's checked for install. Space-separated alternatives are allowed, e.g. `gemini agy` or `cursor-agent agent`; the picker launches whichever is installed and swaps the command's leading binary to match.
- **`*_tmpl`**: assembled at launch. The placeholders `{model}` / `{reasoning}` / `{permission}` decide which layers appear; an agent with no placeholders launches straight away.
- **`*_models` / `*_reason`**: tab-separated menu rows, one row per line: `value<TAB>label`.
- **`*_perms`**: tab-separated permission rows: `value<TAB>flag<TAB>label<TAB>risk`, where risk is `low`, `medium`, or `high`.
- **`*_sysprompt_replace_file` / `*_sysprompt_append_file`**: optional flags for agents that accept a system prompt file. Claude Code uses replacement by default so the picker has just two choices: no prompt, or replace for this session. Do not add these unless the agent's CLI actually supports the flag.
- **`*_defm` / `*_defr` / `*_defp`**: defaults selected when you press Enter.

## How it works

- Runs only in an interactive bash or zsh, and only once per shell tree (`NTAP_DONE` is exported). Each entrypoint bails on the first line under the wrong shell. Everything else is wrapped in that guard, so subshells and scripts do essentially no work.
- **Per-directory memory**: your last choice (agent + model + reasoning + permission, as structured fields) is stored in `${XDG_CONFIG_HOME:-~/.config}/ntap/last` (override with `$NTAP_LAST_FILE`), keyed by `$PWD`, append-only so concurrent terminal opens never clobber it. Opening that directory again offers a one-key **relaunch** or **resume** (e.g. `claude --continue`, `codex resume --last`). The launch command is always rebuilt from the shell source; the file never stores or `eval`s a raw command string.
- **Session prompts**: session-only system prompts are held only for the current picker run. Inline text is written to a private temp file and passed to the agent as a prompt file, then removed after the agent exits.
- **Directory**: at the agent menu, `p`/`path` opens a browser (numbers descend, `..`/`up`/`parent` moves to the folder that contains the current one, `~`/`home` goes to your home folder, `d`/`new` creates a folder in the current location, type a path to jump, Tab completes folders in interactive prompts, Enter uses the current one). `d`/`new` at the agent menu creates a new folder from the start. Either way the `cd` persists for the shell, and the launch (and per-directory memory) use the chosen path.
- **Multiple binaries per agent**: the first installed candidate wins; the launch command's leading binary is swapped to it.
- Choosers never use command-substitution for interactive reads (that fails at shell startup); they set globals instead. User-controlled strings (directory names, `$PWD`, typed input) are `%`-escaped before display so they can't inject prompt escapes.

## Files

- `terminal-agent-picker.sh`: shared shell source and agent definitions
- `terminal-agent-picker.zsh`: small zsh entrypoint; sourced from `~/.zshrc`
- `terminal-agent-picker.bash`: small bash entrypoint; sourced from `~/.bashrc`
- `install.sh`: adds/removes the picker lines (`--uninstall`)
- `CONTRIBUTING.md`: how to add or change an agent
- `NOTES.md`: maintainer/dev notes

## Uninstall

Remove the picker lines from your shell startup file, or run `install.sh --uninstall`.

## License

MIT. See [LICENSE](LICENSE).
