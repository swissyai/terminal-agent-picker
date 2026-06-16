# terminal-agent-picker bash entrypoint.
# Source this from ~/.bashrc. The implementation lives in terminal-agent-picker.sh.

if [ -z "${BASH_VERSION:-}" ]; then
  return 0 2>/dev/null || exit 0
fi

case $- in
  *i*) ;;
  *) return 0 2>/dev/null || exit 0 ;;
esac

if [ -n "${NTAP_DONE:-}" ]; then
  return 0 2>/dev/null || exit 0
fi

export NTAP_DONE=1
NTAP_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$NTAP_ROOT/terminal-agent-picker.sh"
