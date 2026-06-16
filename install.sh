#!/bin/sh
# Adds (or removes) the picker source line in bash/zsh startup files. Idempotent.
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
NAME_MARKER="terminal-agent-picker"
ACTION="install"
TARGET_SHELL=""

usage() {
  cat <<EOF
Usage: ./install.sh [--shell bash|zsh] [--uninstall]

Without --shell, the installer uses your current \$SHELL when it is bash or zsh.
EOF
}

die() {
  echo "$1" >&2
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    --uninstall)
      ACTION="uninstall"
      ;;
    --shell)
      shift
      [ $# -gt 0 ] || die "--shell needs bash or zsh"
      TARGET_SHELL="$1"
      ;;
    --shell=*)
      TARGET_SHELL=${1#--shell=}
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
  shift
done

case "$TARGET_SHELL" in
  ""|bash|zsh) ;;
  *) die "unsupported shell: $TARGET_SHELL (use bash or zsh)" ;;
esac

detect_shell() {
  case "${SHELL##*/}" in
    bash|zsh) printf '%s\n' "${SHELL##*/}" ;;
    *) die "could not detect bash or zsh from SHELL=${SHELL:-unset}; rerun with --shell bash or --shell zsh" ;;
  esac
}

strip_picker_lines() {
  awk -v name_marker="$NAME_MARKER" '
    index($0, name_marker) {
      pending_blank = 0
      next
    }
    $0 == "" {
      if (pending_blank) print ""
      pending_blank = 1
      next
    }
    {
      if (pending_blank) {
        print ""
        pending_blank = 0
      }
      print
    }
    END {
      if (pending_blank) print ""
    }
  '
}

write_source_line() {
  rc=$1
  src=$2
  file_marker=$3
  printf '\n# %s\nsource "%s"\n' "$file_marker" "$src" >> "$rc"
}

install_one() {
  rc=$1
  src=$2
  file_marker=$3
  label=$4

  [ -f "$src" ] || die "missing picker file: $src"

  if [ -f "$rc" ] && grep -qF "source \"$src\"" "$rc"; then
    echo "Already installed in $label"
    return
  fi

  if [ -f "$rc" ] && grep -qF "$NAME_MARKER" "$rc"; then
    tmp="$rc.tmp.$$"
    trap 'rm -f "$tmp"' EXIT HUP INT TERM
    strip_picker_lines < "$rc" > "$tmp"
    mv "$tmp" "$rc"
    trap - EXIT HUP INT TERM
    write_source_line "$rc" "$src" "$file_marker"
    echo "Updated $label. Open a new terminal to use it."
  else
    write_source_line "$rc" "$src" "$file_marker"
    echo "Added to $label. Open a new terminal to use it."
  fi
}

uninstall_one() {
  rc=$1
  label=$2

  if [ -f "$rc" ] && grep -qF "$NAME_MARKER" "$rc"; then
    tmp="$rc.tmp.$$"
    trap 'rm -f "$tmp"' EXIT HUP INT TERM
    strip_picker_lines < "$rc" > "$tmp"
    mv "$tmp" "$rc"
    trap - EXIT HUP INT TERM
    echo "Removed from $label. Open a new terminal."
  fi
}

install_for_shell() {
  shell_name=$1
  case "$shell_name" in
    zsh)
      command -v zsh >/dev/null 2>&1 || die "zsh is not on PATH"
      install_one "$HOME/.zshrc" "$DIR/terminal-agent-picker.zsh" "terminal-agent-picker.zsh" "~/.zshrc"
      ;;
    bash)
      command -v bash >/dev/null 2>&1 || die "bash is not on PATH"
      install_one "$HOME/.bashrc" "$DIR/terminal-agent-picker.bash" "terminal-agent-picker.bash" "~/.bashrc"
      if [ -f "$HOME/.bash_profile" ]; then
        install_one "$HOME/.bash_profile" "$DIR/terminal-agent-picker.bash" "terminal-agent-picker.bash" "~/.bash_profile"
      else
        echo "Note: login bash terminals read ~/.bash_profile. Add the same source line there if your terminal does not read ~/.bashrc."
      fi
      ;;
  esac
}

uninstall_for_shell() {
  shell_name=$1
  case "$shell_name" in
    zsh)
      uninstall_one "$HOME/.zshrc" "~/.zshrc"
      ;;
    bash)
      uninstall_one "$HOME/.bashrc" "~/.bashrc"
      uninstall_one "$HOME/.bash_profile" "~/.bash_profile"
      ;;
  esac
}

if [ -z "$TARGET_SHELL" ]; then
  if [ "$ACTION" = "uninstall" ]; then
    uninstall_for_shell zsh
    uninstall_for_shell bash
    echo "Uninstall complete."
    exit 0
  fi
  TARGET_SHELL=$(detect_shell)
fi

if [ "$ACTION" = "uninstall" ]; then
  uninstall_for_shell "$TARGET_SHELL"
  echo "Uninstall complete."
else
  install_for_shell "$TARGET_SHELL"
fi
