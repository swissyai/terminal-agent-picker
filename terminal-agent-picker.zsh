# terminal-agent-picker zsh entrypoint.
# Source this from ~/.zshrc. The implementation lives in terminal-agent-picker.sh.

if [ -z "$ZSH_VERSION" ]; then
  return 0 2>/dev/null || exit 0
fi

if [[ -o interactive && -z $NTAP_DONE ]]; then
  export NTAP_DONE=1
  typeset -g NTAP_ROOT="${${(%):-%x}:A:h}"

  _ntap_source_core() {
    emulate -L zsh
    setopt KSH_ARRAYS SH_WORD_SPLIT
    source "$NTAP_ROOT/terminal-agent-picker.sh"
  }
  _ntap_source_core
  unset -f _ntap_source_core 2>/dev/null
fi
