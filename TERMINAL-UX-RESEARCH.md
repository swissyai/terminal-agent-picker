# Terminal UX and agent orchestration scan

Checked 2026-08-05. Primary sources only; emphasis on developments from 2025–2026.

## Most useful findings

1. **Use two Zsh modes, not one overloaded “autocomplete” feature.** [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) is the conservative default: async ghost text from history and/or Zsh completion, with whole- or partial-suggestion acceptance. [`zsh-autocomplete`](https://github.com/marlonrichert/zsh-autocomplete) is the fuller, as-you-type completion menu; its latest release is 2025-03-19, but installation replaces normal `compinit` ownership and must happen near the top of `.zshrc`. Recommendation: offer autosuggestions as the safe preset and full autocomplete as an explicit advanced preset, after detecting conflicting `compinit`/plugin-manager setup.

2. **Add fuzzy retrieval, not only prediction.** [`fzf`](https://github.com/junegunn/fzf) embeds Zsh integration (`eval "$(fzf --zsh)"`) for fuzzy history, files, directories, and completion. Version 0.74.2 shipped 2026-08-01 with single-character queries up to 2.4× faster; the 0.74 series also improved tmux/Zellij floating-pane behavior. Recommendation: make fzf-backed directory, history, session, model, and agent pickers an auto-detected enhancement with the current numbered UI as fallback.

3. **Atuin now bridges human shell memory and agents.** Atuin has structured, scoped history search; its July 2026 [built-in MCP server](https://docs.atuin.sh/main/ai/mcp/) lets Claude Code, Cursor, and other clients search commands by project/session, exit status, and author (human vs agent), then fetch selected output line ranges. Its [AI UI](https://docs.atuin.sh/main/ai/introduction/) can generate/insert commands, ask follow-ups, and adds extra confirmation for dangerous or low-confidence commands; the backend was [open-sourced in July 2026](https://docs.atuin.sh/main/ai/self-hosting/). Recommendation: detect Atuin, offer its shell integration/MCP wiring, and preserve actor + exit-code provenance for every command.

4. **Agent terminals are becoming managed threads.** Zed’s [Parallel Agents](https://zed.dev/blog/parallel-agents) (2026-04-22) groups concurrent threads by project with per-thread agent choice and optional worktree isolation; [Terminal Threads](https://zed.dev/blog/terminal-threads) (2026-05-20) gives arbitrary CLI/TUI processes the same project/worktree scope, titles, navigation, and attention notifications. [`cmux`](https://github.com/manaflow-ai/cmux) independently converged on vertical workspace state, unread rings, agent hooks, session restore, splits, and a scriptable socket/CLI. Recommendation: the picker should grow into a small session index—`cwd/worktree`, agent, session ID, status, last event, resume command—not a larger launch menu.

5. **Keep PTYs, but add a structured control plane.** [ACP](https://zed.dev/blog/bring-your-own-agent-to-zed) standardizes agent-to-client streaming, permissions, and review over JSON-RPC; its [registry](https://zed.dev/blog/acp-registry) launched 2026-01-28 with Claude Code, Codex CLI, Copilot CLI, OpenCode, Gemini CLI, and others. OpenAI’s current [`codex app-server`](https://github.com/openai/codex/blob/main/codex-rs/app-server/README.md) exposes thread/turn/item lifecycles, fork/resume/interrupt, streamed diffs and tool activity, approvals, version-matched schemas, stdio, and Unix sockets. Recommendation: normalize supported agents into internal lifecycle events and use ANSI/PTY observation only as the universal fallback.

6. **Model long-running work as durable tasks.** Experimental [MCP Tasks](https://modelcontextprotocol.io/specification/2025-11-25/basic/utilities/tasks), introduced in the 2025-11-25 spec, provides task IDs; `working`, `input_required`, `completed`, `failed`, and `cancelled` states; polling hints; TTL; result retrieval; and cancellation. This is a strong internal state model even before exposing MCP: an orchestrator can reconnect, identify which terminal needs input, cancel cleanly, and collect results without pretending every job is one synchronous shell command.

7. **Sandboxing belongs below the command string.** Zed’s post published [today](https://zed.dev/blog/sandboxing) describes OS-enforced defaults for agent terminal/fetch tools: no writes outside project roots, no `.git` writes, and no network unless elevated, implemented with Seatbelt on macOS, Bubblewrap on Linux, and WSL on Windows. Grants show scope and reason and can be one-time, thread-long, or permanent. The post also demonstrates why command-pattern deny lists are bypassable and documents a symlink-swap/TOCTOU threat. Recommendation: keep the picker’s Plan/Standard/Auto language, but eventually back Standard with an OS sandbox and explicit capability grants.

8. **Notifications and observability are first-class UX.** cmux uses OSC 9/99/777 plus agent hooks to identify the pane needing attention; Claude Code’s [hook surface](https://code.claude.com/docs/en/hooks) includes permission, stop/failure, subagent, teammate-idle, task, worktree, cwd, and file events. Recommendation: define one local event envelope—`session`, `actor`, `cwd`, `worktree`, `state`, `command/tool`, `approval`, `exit`, `duration`, redacted output pointer—and let terminal UIs, status bars, logs, and orchestrators consume it.

## Suggested order

1. Optional human-UX installer: autosuggestions + fzf + Atuin detection; full `zsh-autocomplete` behind an advanced choice.
2. Session registry and hook adapters: status, attention, resume, command provenance.
3. Worktree isolation and OS-backed Standard sandbox.
4. ACP/Codex structured adapters plus PTY fallback, using an MCP-like durable task state machine.

The main product seam is now clear: preserve a pleasant human Zsh/PTY, while adding structured session state, events, policy, and isolation for agents.
