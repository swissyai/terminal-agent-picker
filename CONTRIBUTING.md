# Contributing

This repo is plain shell. There is no generator and no build step.

## Adding or changing an agent

1. Edit `terminal-agent-picker.sh`.
2. Add or update the `NTAP_<key>_*` variables near the top of the file.
3. Run the syntax and smoke checks.

The bash and zsh entrypoints are intentionally small wrappers. Most behavior belongs in `terminal-agent-picker.sh`.

## Before you add an agent to the default list

Verify its CLI flags against the real binary. The five verified agents (Claude Code, Codex, Gemini, opencode, Cursor) were checked locally; the long tail is research-derived and explicitly hedged in the README. A wrong flag on a permission tier can launch an agent more permissively than the label claims, so confirm the `--dangerously`/`yolo`/`--auto` mappings in particular.

## Engine changes

Run `bash -n terminal-agent-picker.bash terminal-agent-picker.sh` and `zsh -n terminal-agent-picker.zsh terminal-agent-picker.sh`, then confirm each entrypoint no-ops cleanly under the wrong shell. If you touch launch assembly, run the fake-agent smoke tests in CI locally.

## Requirements

- bash or zsh
