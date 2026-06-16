# terminal-agent-picker shared shell core.
# Hand-authored source for bash and zsh. This file is meant to be read, edited,
# and sourced through terminal-agent-picker.bash or terminal-agent-picker.zsh.

if [ -z "${BASH_VERSION:-}${ZSH_VERSION:-}" ]; then
  return 0 2>/dev/null || exit 0
fi

case $- in
  *i*) ;;
  *) return 0 2>/dev/null || exit 0 ;;
esac

if [[ -n ${ZSH_VERSION:-} ]]; then
  setopt KSH_ARRAYS SH_WORD_SPLIT 2>/dev/null || true
fi

NTAP_ORDER=($'claude' $'codex' $'droid' $'amp' $'gemini' $'opencode' $'aider' $'goose' $'crush' $'cursor' $'copilot' $'qwen' $'openhands' $'rovodev' $'kilo' $'continue' $'gptme' $'kiro' $'pi' $'hermes' $'plandex' $'openhands-mini')
NTAP_claude_label=$'Claude Code'
NTAP_claude_bins=$'claude'
NTAP_claude_tmpl=$'claude --model {model} --effort {reasoning} {permission}'
NTAP_claude_models=$'fable\tFable 5 (highest capability)\nopus\tOpus 4.8 (frontier Opus)\nopusplan\tOpus-plan (Opus plans, Sonnet executes)\nsonnet\tSonnet 4.6 (daily driver)\nopus[1m]\tOpus 4.8 (1M context)\nsonnet[1m]\tSonnet 4.6 (1M context)\nhaiku\tHaiku 4.5 (fast/cheap)'
NTAP_claude_reason=$'low\tLow (latency-sensitive)\nmedium\tMedium (cost-sensitive)\nhigh\tHigh (default on Fable 5 / Opus / Sonnet)\nxhigh\txHigh (Fable 5 / Opus 4.8/4.7 only)\nmax\tMax (deepest, session-only)'
NTAP_claude_perms=$'plan\t--permission-mode plan\tPlan: read & explore, no writes\tlow\nstandard\t--permission-mode acceptEdits\tStandard: edits here, asks before risky\tmedium\nauto\t--dangerously-skip-permissions\tAuto: runs autonomously, no prompts\thigh'
NTAP_claude_resume=$'--continue'
NTAP_claude_sysprompt_replace_file=$'--system-prompt-file'
NTAP_claude_defm=$'sonnet'
NTAP_claude_defr=$'high'
NTAP_claude_defp=$'standard'

NTAP_codex_label=$'OpenAI Codex CLI'
NTAP_codex_bins=$'codex'
NTAP_codex_tmpl=$'codex -m {model} -c model_reasoning_effort="{reasoning}" {permission}'
NTAP_codex_models=$'gpt-5.5\tGPT-5.5 (strongest overall)\ngpt-5.4\tGPT-5.4 (balanced flagship)\ngpt-5.4-mini\tGPT-5.4-mini (fast/cheap, caps at high)\ngpt-5.3-codex-spark\tGPT-5.3 Codex Spark (near-instant, Pro only)'
NTAP_codex_reason=$'minimal\tMinimal\nlow\tLow\nmedium\tMedium (default)\nhigh\tHigh\nxhigh\txHigh (gpt-5.5/gpt-5.4 only)'
NTAP_codex_perms=$'plan\t-s read-only -a on-request\tPlan: read & explore, no writes\tlow\nstandard\t-s workspace-write -a on-request\tStandard: edits here, asks before risky\tmedium\nauto\t--dangerously-bypass-approvals-and-sandbox\tAuto: runs autonomously, no prompts\thigh'
NTAP_codex_resume=$'resume --last'
NTAP_codex_defm=$'gpt-5.5'
NTAP_codex_defr=$'high'
NTAP_codex_defp=$'standard'

NTAP_droid_label=$'Droid (Factory.ai)'
NTAP_droid_bins=$'droid'
NTAP_droid_tmpl=$'droid'
NTAP_droid_defm=$''
NTAP_droid_defr=$''
NTAP_droid_defp=$''

NTAP_amp_label=$'Amp (Sourcegraph)'
NTAP_amp_bins=$'amp'
NTAP_amp_tmpl=$'amp {permission}'
NTAP_amp_perms=$'default\t\tDefault (autonomous, no approval prompts)\tmedium\nallow-all\t--dangerously-allow-all\tDangerously allow all (bypass restrictions)\thigh'
NTAP_amp_defm=$''
NTAP_amp_defr=$''
NTAP_amp_defp=$'default'

NTAP_gemini_label=$'Google Gemini CLI'
NTAP_gemini_bins=$'gemini agy'
NTAP_gemini_tmpl=$'gemini -m {model} {permission}'
NTAP_gemini_models=$'gemini-3.1-pro-preview\tGemini 3.1 Pro (latest Pro)\ngemini-2.5-pro\tGemini 2.5 Pro (strong coder)\ngemini-3-flash\tGemini 3 Flash (fast)\nauto\tAuto (routes pro/flash)'
NTAP_gemini_perms=$'plan\t--approval-mode plan\tPlan: read & explore, no writes\tlow\nstandard\t--approval-mode auto_edit\tStandard: edits here, asks before risky\tmedium\nauto\t--approval-mode yolo\tAuto: runs autonomously, no prompts\thigh'
NTAP_gemini_resume=$'--resume latest'
NTAP_gemini_defm=$'gemini-3.1-pro-preview'
NTAP_gemini_defr=$''
NTAP_gemini_defp=$'standard'

NTAP_opencode_label=$'opencode (SST)'
NTAP_opencode_bins=$'opencode'
NTAP_opencode_tmpl=$'opencode --model {model} --variant {reasoning} {permission}'
NTAP_opencode_models=$'anthropic/claude-sonnet-4-6\tClaude Sonnet 4.6 (strong default)\nanthropic/claude-opus-4-7\tClaude Opus 4.7 (best reasoning)\nopenai/gpt-5.1-codex\tGPT-5.1 Codex (code-specialized)\nopenai/gpt-5\tGPT-5 (OpenAI flagship)\ngoogle/gemini-3-pro\tGemini 3 Pro\nopenrouter/moonshot/kimi-k2.5\tKimi K2.5 (open-source via OpenRouter)'
NTAP_opencode_reason=$'low\tLow\nmedium\tMedium (OpenAI)\nhigh\tHigh (default when thinking on)\nmax\tMax (Anthropic max budget)\nxhigh\txHigh (OpenAI only)'
NTAP_opencode_perms=$'plan\t--agent plan\tPlan: read & explore, no writes\tlow\nstandard\t--agent build\tStandard: edits here, asks before risky\tmedium\nauto\t--dangerously-skip-permissions\tAuto: runs autonomously, no prompts\thigh'
NTAP_opencode_resume=$'--continue'
NTAP_opencode_defm=$'anthropic/claude-sonnet-4-6'
NTAP_opencode_defr=$'high'
NTAP_opencode_defp=$'standard'

NTAP_aider_label=$'Aider'
NTAP_aider_bins=$'aider'
NTAP_aider_tmpl=$'aider --model {model} --reasoning-effort {reasoning} {permission}'
NTAP_aider_models=$'claude-sonnet-4-6\tClaude Sonnet 4.6\nclaude-opus-4-7\tClaude Opus 4.7\no3\tOpenAI o3\ngemini/gemini-2.5-pro\tGemini 2.5 Pro\no4-mini\tOpenAI o4-mini\ndeepseek/deepseek-reasoner\tDeepSeek R1'
NTAP_aider_reason=$'low\tLow (o-series effort)\nmedium\tMedium (o-series effort)\nhigh\tHigh (o-series effort)'
NTAP_aider_perms=$'dry-run\t--dry-run\tDry run (show edits, write nothing)\tlow\ndefault\t\tDefault (prompt before every edit)\tlow\nauto-test\t--auto-test\tAuto-test after each change\tmedium\nyes-always\t--yes-always\tYes-always (auto-confirm all prompts)\thigh'
NTAP_aider_defm=$'claude-sonnet-4-6'
NTAP_aider_defr=$'high'
NTAP_aider_defp=$'default'

NTAP_goose_label=$'Goose (Block / AAIF)'
NTAP_goose_bins=$'goose'
NTAP_goose_tmpl=$'goose session'
NTAP_goose_defm=$''
NTAP_goose_defr=$''
NTAP_goose_defp=$''

NTAP_crush_label=$'Crush (Charmbracelet)'
NTAP_crush_bins=$'crush'
NTAP_crush_tmpl=$'crush'
NTAP_crush_defm=$''
NTAP_crush_defr=$''
NTAP_crush_defp=$''

NTAP_cursor_label=$'Cursor CLI'
NTAP_cursor_bins=$'cursor-agent agent'
NTAP_cursor_tmpl=$'cursor-agent --model {model} {permission}'
NTAP_cursor_models=$'claude-opus-4-8\tClaude Opus 4.8 (top frontier)\ngpt-5.5\tGPT-5.5 (top OpenAI)\ncomposer-2.5\tComposer 2.5 (Cursor native)\nclaude-opus-4-7\tClaude Opus 4.7 (faster)\ngemini-3.1-pro\tGemini 3.1 Pro (long context)\ngrok-build-0.1\tGrok Build (xAI)'
NTAP_cursor_perms=$'plan\t--mode=plan\tPlan: read & explore, no writes\tlow\nstandard\t\tStandard: full agent (policy from Cursor settings)\tmedium'
NTAP_cursor_defm=$'claude-opus-4-8'
NTAP_cursor_defr=$''
NTAP_cursor_defp=$'standard'

NTAP_copilot_label=$'GitHub Copilot CLI'
NTAP_copilot_bins=$'copilot'
NTAP_copilot_tmpl=$'copilot {permission}'
NTAP_copilot_perms=$'default\t\tDefault (approval prompts)\tlow\ncloud\t--cloud\tCloud (sandboxed session)\tmedium\nyolo\t--allow-all\tAllow-all / autopilot (skip all approvals)\thigh'
NTAP_copilot_defm=$''
NTAP_copilot_defr=$''
NTAP_copilot_defp=$'default'

NTAP_qwen_label=$'Qwen Code'
NTAP_qwen_bins=$'qwen'
NTAP_qwen_tmpl=$'qwen -m {model} {permission}'
NTAP_qwen_models=$'qwen3.6-plus\tQwen3.6-Plus (latest, ModelStudio)\nclaude-sonnet-4-6\tClaude Sonnet 4.6 (via compatible API)\ngemini-2.5-pro\tGemini 2.5 Pro (via compatible API)'
NTAP_qwen_perms=$'default\t\tDefault (confirm before actions)\tlow\nyolo\t--yolo\tYOLO (skip all approvals)\thigh'
NTAP_qwen_defm=$'qwen3.6-plus'
NTAP_qwen_defr=$''
NTAP_qwen_defp=$'default'

NTAP_openhands_label=$'OpenHands CLI'
NTAP_openhands_bins=$'openhands'
NTAP_openhands_tmpl=$'openhands {permission}'
NTAP_openhands_perms=$'default\t\tDefault (confirm write/shell ops)\tlow\nllm-approve\t--llm-approve\tLLM-based approval analyser\tmedium\nalways-approve\t--always-approve\tAlways-approve / YOLO (skip all prompts)\thigh'
NTAP_openhands_defm=$''
NTAP_openhands_defr=$''
NTAP_openhands_defp=$'default'

NTAP_rovodev_label=$'Rovo Dev CLI (Atlassian)'
NTAP_rovodev_bins=$'acli'
NTAP_rovodev_tmpl=$'acli rovodev run {permission}'
NTAP_rovodev_perms=$'ask\t\tDefault with /ask read-only available\tlow\nyolo\t--yolo\tYOLO (skip all permission requests)\thigh'
NTAP_rovodev_defm=$''
NTAP_rovodev_defr=$''
NTAP_rovodev_defp=$'ask'

NTAP_kilo_label=$'Kilo Code CLI'
NTAP_kilo_bins=$'kilo'
NTAP_kilo_tmpl=$'kilo --model {model}'
NTAP_kilo_models=$'anthropic/claude-sonnet-4-6\tClaude Sonnet 4.6 (recommended)\nanthropic/claude-opus-4-7\tClaude Opus 4.7\nopenai/gpt-5\tGPT-5'
NTAP_kilo_defm=$'anthropic/claude-sonnet-4-6'
NTAP_kilo_defr=$''
NTAP_kilo_defp=$''

NTAP_continue_label=$'Continue CLI (cn)'
NTAP_continue_bins=$'cn'
NTAP_continue_tmpl=$'cn {permission}'
NTAP_continue_perms=$'default\t\tDefault (read-only auto, confirm write/shell)\tlow\nheadless\t--headless\tHeadless (non-interactive CI)\tmedium'
NTAP_continue_defm=$''
NTAP_continue_defr=$''
NTAP_continue_defp=$'default'

NTAP_gptme_label=$'gptme'
NTAP_gptme_bins=$'gptme'
NTAP_gptme_tmpl=$'gptme -m {model} {permission}'
NTAP_gptme_models=$'claude-sonnet-4-6\tClaude Sonnet 4.6\ngpt-4o\tGPT-4o\ngemini-2.5-pro\tGemini 2.5 Pro'
NTAP_gptme_perms=$'default\t\tDefault (prompt before actions)\tmedium\nno-confirm\t-y\tNo-confirm (skip all prompts)\thigh\nnon-interactive\t-n\tNon-interactive (implies no-confirm)\thigh'
NTAP_gptme_defm=$'claude-sonnet-4-6'
NTAP_gptme_defr=$''
NTAP_gptme_defp=$'default'

NTAP_kiro_label=$'Kiro CLI (AWS)'
NTAP_kiro_bins=$'kiro'
NTAP_kiro_tmpl=$'kiro'
NTAP_kiro_defm=$''
NTAP_kiro_defr=$''
NTAP_kiro_defp=$''

NTAP_pi_label=$'Pi (earendil-works)'
NTAP_pi_bins=$'pi'
NTAP_pi_tmpl=$'pi --model {model} --thinking {reasoning} {permission}'
NTAP_pi_models=$'claude-opus-4-8\tClaude Opus 4.8 (top SWE-bench)\nclaude-sonnet-4-6\tClaude Sonnet 4.6 (best price/perf)\nopenai/gpt-5.5\tGPT-5.5\ngoogle/gemini-3.1-pro\tGemini 3.1 Pro\nxai/grok-4\tGrok 4'
NTAP_pi_reason=$'off\tOff\nminimal\tMinimal\nlow\tLow\nmedium\tMedium\nhigh\tHigh\nxhigh\txHigh (flag only)'
NTAP_pi_perms=$'read-only\t--tools read,grep,find,ls\tRead-only (disables write/edit/bash)\tlow\nno-bash\t--exclude-tools bash\tNo shell (keeps file tools)\tlow\ndefault\t\tDefault (full tools: read/write/edit/bash)\thigh'
NTAP_pi_defm=$'claude-sonnet-4-6'
NTAP_pi_defr=$'high'
NTAP_pi_defp=$'read-only'

NTAP_hermes_label=$'Hermes Agent (Nous Research)'
NTAP_hermes_bins=$'hermes'
NTAP_hermes_tmpl=$'hermes --tui -m {model} {permission}'
NTAP_hermes_models=$'claude-opus-4-7\tClaude Opus 4.7 (highest ceiling)\nclaude-sonnet-4-6\tClaude Sonnet 4.6 (Nous-recommended)\ngpt-5.5\tGPT-5.5 (#1 Terminal-Bench)\ngemini-2.5-pro\tGemini 2.5 Pro (1M context)\nkimi-k2-6\tKimi K2.6 (open-weights)\ndeepseek-v4\tDeepSeek V4 (budget)'
NTAP_hermes_perms=$'default\t\tManual (prompts before flagged commands)\tlow\ncheckpoints\t--checkpoints\tManual + filesystem checkpoints (undo)\tlow\nyolo\t--yolo\tYOLO (bypass approvals; hardline blocklist stays)\thigh'
NTAP_hermes_defm=$'claude-sonnet-4-6'
NTAP_hermes_defr=$''
NTAP_hermes_defp=$'checkpoints'

NTAP_plandex_label=$'Plandex'
NTAP_plandex_bins=$'plandex'
NTAP_plandex_tmpl=$'plandex {permission}'
NTAP_plandex_perms=$'review\t\tPlanning sandbox (changes held until applied)\tlow\nauto-debug\t--auto-debug\tAuto-debug terminal errors\tmedium'
NTAP_plandex_defm=$''
NTAP_plandex_defr=$''
NTAP_plandex_defp=$'review'

NTAP_openhands_mini_label=$'mini-SWE-agent'
NTAP_openhands_mini_bins=$'mini'
NTAP_openhands_mini_tmpl=$'mini --model {model} {permission}'
NTAP_openhands_mini_models=$'claude-sonnet-4-6\tClaude Sonnet 4.6\ngpt-4o\tGPT-4o'
NTAP_openhands_mini_perms=$'patch-local\t--actions.apply_patch_locally\tApply patch to local files\tmedium\nopen-pr\t--actions.open_pr\tAuto-submit PR\thigh'
NTAP_openhands_mini_defm=$'claude-sonnet-4-6'
NTAP_openhands_mini_defr=$''
NTAP_openhands_mini_defp=$'patch-local'


# ===== engine ================================================================
_ntap_init_colors() {
  if [[ -t 1 && -z ${NO_COLOR:-} ]]; then
    NTAP_ACC=$'\033[38;5;75m'; NTAP_DIM=$'\033[38;5;244m'; NTAP_OK=$'\033[32m'
    NTAP_WARN=$'\033[33m'; NTAP_ERR=$'\033[31m'; NTAP_BOLD=$'\033[1m'; NTAP_RST=$'\033[0m'
  else
    NTAP_ACC=""; NTAP_DIM=""; NTAP_OK=""; NTAP_WARN=""; NTAP_ERR=""; NTAP_BOLD=""; NTAP_RST=""
  fi
}

_ntap_keyvar() { printf '%s' "${1//-/_}"; }
_ntap_get() {
  local sk var val
  sk=$(_ntap_keyvar "$1")
  var="NTAP_${sk}_${2}"
  eval "val=\${$var-}"
  printf '%s' "$val"
}
_ntap_shell_quote() { printf '%q' "$1"; }
_ntap_is_uint() { case ${1:-} in ''|*[!0-9]*) return 1 ;; *) return 0 ;; esac; }
_ntap_new_mode() {
  case ${NTAP_MODE:-${NTAP_TERMINAL_MODE:-terminal-native}} in
    new|terminal-new|beginner|friendly) return 0 ;;
    *) return 1 ;;
  esac
}
_ntap_is_back()    { [[ $1 == b || $1 == back || $1 == cancel ]]; }
_ntap_is_shell()   { [[ $1 == q || $1 == s || $1 == quit || $1 == shell ]]; }
_ntap_is_resume()  { [[ $1 == r || $1 == resume ]]; }
_ntap_is_choose()  { [[ $1 == c || $1 == choose || $1 == change ]]; }
_ntap_is_pathpick(){ [[ $1 == p || $1 == path || $1 == folder || $1 == directory || $1 == dir || $1 == cd ]]; }
_ntap_is_newdir()  { [[ $1 == d || $1 == n || $1 == + || $1 == new || $1 == create || $1 == mkdir ]]; }
_ntap_is_up()      { [[ $1 == ".." || $1 == up || $1 == parent || $1 == containing ]]; }
_ntap_is_home()    { [[ $1 == "~" || $1 == home ]]; }
_ntap_is_sysprompt(){ [[ $1 == y || $1 == prompt || $1 == prompts || $1 == system || $1 == "system prompt" || $1 == instructions || $1 == rules ]]; }
_ntap_is_full_sysprompt(){ [[ $1 == full || $1 == replace || $1 == full-system || $1 == system-full || $1 == "full system" || $1 == "replace system" ]]; }
_ntap_is_clear()   { [[ $1 == clear || $1 == none || $1 == off || $1 == remove || $1 == reset ]]; }

_ntap_read_path() {
  NTAP_INPUT=""
  if [[ -n ${ZSH_VERSION:-} && -t 0 && -t 1 ]]; then
    local value=""
    vared -p "$1" value || return 1
    NTAP_INPUT=$value
  elif [[ -t 0 && -t 1 ]]; then
    read -e -r -p "$1" NTAP_INPUT || return 1
  else
    printf '%s' "$1"
    read -r NTAP_INPUT || return 1
  fi
}

_ntap_session_prompt_set() {
  [[ -n ${NTAP_SESSION_PROMPT_TEXT:-} || -n ${NTAP_SESSION_PROMPT_FILE:-} ]]
}

_ntap_prompt_supported() {
  local k=$1 mode=${2:-append}
  if [[ $mode == replace ]]; then
    [[ -n $(_ntap_get "$k" sysprompt_replace_file) ]]
  else
    [[ -n $(_ntap_get "$k" sysprompt_append_file) ]]
  fi
}

_ntap_cleanup_session_prompt_temp() {
  [[ -n ${NTAP_SESSION_PROMPT_TEMP:-} ]] && rm -f -- "$NTAP_SESSION_PROMPT_TEMP" 2>/dev/null
  NTAP_SESSION_PROMPT_TEMP=""
}

_ntap_resolve_prompt_file() {
  local file=${1#@} candidate cfg
  NTAP_PROMPT_FILE=""
  [[ -z $file ]] && return 1
  [[ $file == "~" ]] && file=$HOME
  [[ $file == "~/"* ]] && file=${file/#\~/$HOME}
  cfg=${XDG_CONFIG_HOME:-$HOME/.config}/terminal-agent-picker
  local tries=("$file")
  if [[ $file != /* ]]; then
    [[ -n ${NTAP_ROOT:-} ]] && tries+=("$NTAP_ROOT/$file")
    if [[ $file != */* ]]; then
      tries+=("local-prompts/$file")
      [[ -n ${NTAP_ROOT:-} ]] && tries+=("$NTAP_ROOT/local-prompts/$file")
      tries+=("$cfg/local-prompts/$file")
    fi
  fi
  for candidate in "${tries[@]}"; do
    [[ $candidate == "~" ]] && candidate=$HOME
    [[ $candidate == "~/"* ]] && candidate=${candidate/#\~/$HOME}
    if [[ -r $candidate && -f $candidate ]]; then
      NTAP_PROMPT_FILE=$candidate
      return 0
    fi
  done
  return 1
}

_ntap_set_session_prompt() {
  NTAP_REPLY=""
  local mode=${1:-append} ans file title
  [[ $mode == replace ]] && title="Replace system prompt (this session only)" || title="Session system prompt"
  while true; do
    printf '\n  %s❯%s %s%s%s\n' "$NTAP_ACC" "$NTAP_RST" "$NTAP_BOLD" "$title" "$NTAP_RST"
    if _ntap_new_mode; then
      if [[ $mode == replace ]]; then
        printf '  %stype prompt file path · also checks picker local-prompts · Tab paths · clear · back%s\n' "$NTAP_DIM" "$NTAP_RST"
      else
        printf '  %stype one-line instructions · @file for longer prompt · clear · back%s\n' "$NTAP_DIM" "$NTAP_RST"
      fi
    else
      if [[ $mode == replace ]]; then
        printf '  %sprompt file path · checks picker local-prompts · Tab paths · clear · b back%s\n' "$NTAP_DIM" "$NTAP_RST"
      else
        printf '  %sone-line prompt · @file · clear · b back%s\n' "$NTAP_DIM" "$NTAP_RST"
      fi
    fi
    if _ntap_session_prompt_set; then
      if [[ -n ${NTAP_SESSION_PROMPT_FILE:-} ]]; then
        printf '  current: %s%s @%s%s\n' "$NTAP_OK" "${NTAP_SESSION_PROMPT_MODE:-append}" "$NTAP_SESSION_PROMPT_FILE" "$NTAP_RST"
      else
        printf '  current: %s%s inline prompt set%s\n' "$NTAP_OK" "${NTAP_SESSION_PROMPT_MODE:-append}" "$NTAP_RST"
      fi
    fi
    if [[ $mode == replace ]]; then
      _ntap_read_path "  ❯ " || return 0
      ans=$NTAP_INPUT
    else
      printf '  %s❯%s ' "$NTAP_ACC" "$NTAP_RST"
      read -r ans || return 0
    fi
    [[ -z $ans ]] && { NTAP_REPLY=__NTAP_BACK__; return 0; }
    if _ntap_is_back "$ans"; then NTAP_REPLY=__NTAP_BACK__; return 0; fi
    if _ntap_is_shell "$ans"; then NTAP_REPLY=__NTAP_QUIT__; return 0; fi
    if _ntap_is_clear "$ans"; then
      _ntap_cleanup_session_prompt_temp
      NTAP_SESSION_PROMPT_TEXT=""; NTAP_SESSION_PROMPT_FILE=""; NTAP_SESSION_PROMPT_MODE=""
      printf '  %ssession prompt cleared%s\n' "$NTAP_OK" "$NTAP_RST"
      NTAP_REPLY=__NTAP_OK__
      return 0
    fi
    [[ $mode == replace && $ans != @* ]] && ans="@$ans"
    if [[ $ans == @* ]]; then
      if _ntap_resolve_prompt_file "$ans"; then
        file=$NTAP_PROMPT_FILE
        _ntap_cleanup_session_prompt_temp
        NTAP_SESSION_PROMPT_FILE=$file
        NTAP_SESSION_PROMPT_TEXT=""
        NTAP_SESSION_PROMPT_MODE=$mode
        if [[ $mode == replace ]]; then
          printf '  %ssystem prompt replaced for this session%s  %s\n' "$NTAP_OK" "$NTAP_RST" "$file"
        else
          printf '  %ssession prompt set from file for this session%s  %s\n' "$NTAP_OK" "$NTAP_RST" "$file"
        fi
        NTAP_REPLY=__NTAP_OK__
        return 0
      fi
      file=${ans#@}
      [[ $file == "~"* ]] && file=${file/#\~/$HOME}
      printf '  %snot a readable file%s  %s\n' "$NTAP_ERR" "$NTAP_RST" "$file"
      [[ $mode == replace && $file != /* && -n ${NTAP_ROOT:-} ]] && printf '  %schecked current folder and %s/local-prompts%s\n' "$NTAP_DIM" "$NTAP_ROOT" "$NTAP_RST"
      continue
    fi
    _ntap_cleanup_session_prompt_temp
    NTAP_SESSION_PROMPT_TEXT=$ans
    NTAP_SESSION_PROMPT_FILE=""
    NTAP_SESSION_PROMPT_MODE=$mode
    printf '  %ssession prompt set for this launch only%s\n' "$NTAP_OK" "$NTAP_RST"
    NTAP_REPLY=__NTAP_OK__
    return 0
  done
}

_ntap_pick_session_prompt() {
  local alabel=$1 k=$2 pick hint err i
  local vals=("none") lbls=("No custom system prompt")
  _ntap_prompt_supported "$k" append && { vals+=("append"); lbls+=("Add session instructions (text or @file)"); }
  _ntap_prompt_supported "$k" replace && { vals+=("replace"); lbls+=("Replace system prompt for this session"); }
  while true; do
    printf '\n  %s❯%s %s%s  ›  system prompt%s\n' "$NTAP_ACC" "$NTAP_RST" "$NTAP_BOLD" "$alabel" "$NTAP_RST"
    if _ntap_new_mode; then
      hint="type a number · Enter keeps default · back · shell"; err="type a number 1-${#vals[@]}, back, or shell"
    else
      hint="number to choose · enter = default · b back · q shell"; err="enter a number 1-${#vals[@]}, or b / q"
    fi
    printf '  %s%s%s\n\n' "$NTAP_DIM" "$hint" "$NTAP_RST"
    for (( i = 0; i < ${#vals[@]}; i++ )); do
      if [[ ${vals[i]} == none ]]; then
        printf '    %s%s%s%s  %s  %s(default · enter)%s\n' "$NTAP_ACC" "$NTAP_BOLD" "$((i+1))" "$NTAP_RST" "${lbls[i]}" "$NTAP_DIM" "$NTAP_RST"
      else
        printf '    %s%s%s%s  %s\n' "$NTAP_ACC" "$NTAP_BOLD" "$((i+1))" "$NTAP_RST" "${lbls[i]}"
      fi
    done
    printf '  %s❯%s ' "$NTAP_ACC" "$NTAP_RST"
    read -r pick || { NTAP_REPLY=__NTAP_QUIT__; return; }
    if [[ -z $pick ]]; then pick=1
    elif _ntap_is_back "$pick"; then NTAP_REPLY=__NTAP_BACK__; return
    elif _ntap_is_shell "$pick"; then NTAP_REPLY=__NTAP_QUIT__; return
    elif _ntap_is_sysprompt "$pick" && _ntap_prompt_supported "$k" append; then pick=2
    elif _ntap_is_sysprompt "$pick" && _ntap_prompt_supported "$k" replace; then pick=${#vals[@]}
    elif _ntap_is_full_sysprompt "$pick" && _ntap_prompt_supported "$k" replace; then pick=${#vals[@]}
    elif ! _ntap_is_uint "$pick" || (( ${#pick} > 6 || pick < 1 || pick > ${#vals[@]} )); then
      printf '  %s?%s  %s\n' "$NTAP_WARN" "$NTAP_RST" "$err"
      continue
    fi
    case ${vals[pick-1]} in
      none)
        _ntap_cleanup_session_prompt_temp
        NTAP_SESSION_PROMPT_TEXT=""; NTAP_SESSION_PROMPT_FILE=""; NTAP_SESSION_PROMPT_MODE=""
        NTAP_REPLY=__NTAP_OK__
        return
        ;;
      append|replace)
        _ntap_set_session_prompt "${vals[pick-1]}"
        [[ $NTAP_REPLY == __NTAP_OK__ || $NTAP_REPLY == __NTAP_QUIT__ ]] && return
        continue
        ;;
    esac
  done
}

_ntap_prepare_session_prompt() {
  local k=$1 mode=${NTAP_SESSION_PROMPT_MODE:-append} f old_umask rc
  NTAP_PROMPT_FILE=""
  _ntap_session_prompt_set || return 1
  _ntap_prompt_supported "$k" "$mode" || return 1
  if [[ -n ${NTAP_SESSION_PROMPT_FILE:-} ]]; then
    NTAP_PROMPT_FILE=$NTAP_SESSION_PROMPT_FILE
    return 0
  fi
  _ntap_cleanup_session_prompt_temp
  f="${TMPDIR:-/tmp}/ntap-system-prompt.$$.${RANDOM}.txt"
  old_umask=$(umask)
  umask 077
  printf '%s\n' "$NTAP_SESSION_PROMPT_TEXT" > "$f"
  rc=$?
  umask "$old_umask"
  (( rc == 0 )) || return 1
  NTAP_SESSION_PROMPT_TEMP=$f
  NTAP_PROMPT_FILE=$f
}

_ntap_pick() {
  local title=$1 list=$2 def=$3 line p hint err i value label rest after_flag risk
  local vals=() lbls=()
  while IFS= read -r line; do
    [[ -z $line ]] && continue
    value=${line%%$'\t'*}
    rest=${line#*$'\t'}
    label=$rest
    risk=""
    if [[ $rest == *$'\t'* ]]; then
      after_flag=${rest#*$'\t'}
      label=${after_flag%%$'\t'*}
      [[ $after_flag == *$'\t'* ]] && risk=${after_flag##*$'\t'}
    fi
    [[ -z $value ]] && continue
    case $risk in
      low) label="${NTAP_OK}${label}${NTAP_RST}" ;;
      medium) label="${NTAP_WARN}${label}${NTAP_RST}" ;;
      high) label="${NTAP_ERR}${label}${NTAP_RST}" ;;
    esac
    vals+=("$value"); lbls+=("$label")
  done <<< "$list"
  if (( ${#vals[@]} == 0 )); then NTAP_REPLY=$def; return; fi
  while true; do
    printf '\n  %s❯%s %s%s%s\n' "$NTAP_ACC" "$NTAP_RST" "$NTAP_BOLD" "$title" "$NTAP_RST"
    if _ntap_new_mode; then
      hint="type a number · Enter keeps default · back · shell"; err="type a number 1-${#vals[@]}, back, or shell"
    else
      hint="number to choose · enter = default · b back · q shell"; err="enter a number 1-${#vals[@]}, or b / q"
    fi
    printf '  %s%s%s\n\n' "$NTAP_DIM" "$hint" "$NTAP_RST"
    for (( i = 0; i < ${#vals[@]}; i++ )); do
      if [[ ${vals[i]} == "$def" ]]; then
        printf '    %s%s%s%s  %s  %s(default · enter)%s\n' "$NTAP_ACC" "$NTAP_BOLD" "$((i+1))" "$NTAP_RST" "${lbls[i]}" "$NTAP_DIM" "$NTAP_RST"
      else
        printf '    %s%s%s%s  %s\n' "$NTAP_ACC" "$NTAP_BOLD" "$((i+1))" "$NTAP_RST" "${lbls[i]}"
      fi
    done
    printf '  %s❯%s ' "$NTAP_ACC" "$NTAP_RST"
    read -r p || { NTAP_REPLY=__NTAP_QUIT__; return; }
    if [[ -z $p ]]; then NTAP_REPLY=$def; return
    elif _ntap_is_back "$p"; then NTAP_REPLY=__NTAP_BACK__; return
    elif _ntap_is_shell "$p"; then NTAP_REPLY=__NTAP_QUIT__; return
    elif _ntap_is_uint "$p" && (( ${#p} <= 6 && p >= 1 && p <= ${#vals[@]} )); then NTAP_REPLY=${vals[p-1]}; return
    else printf '  %s?%s  %s\n' "$NTAP_WARN" "$NTAP_RST" "$err"; fi
  done
}

_ntap_flag_for() {
  NTAP_FLAG=""
  local list=$1 want=$2 value flag label
  while IFS=$'\t' read -r value flag label; do
    [[ -z $value ]] && continue
    if [[ $value == "$want" ]]; then NTAP_FLAG=$flag; return; fi
  done <<< "$list"
}

_ntap_build() {
  local k=$1 model=$2 reasoning=$3 perm=$4 sysprompt_file=${5:-} sysprompt_mode=${6:-append}
  local tmpl bins rbin="" b lead permflag="" cmd q spflag
  NTAP_CMD=""
  tmpl=$(_ntap_get "$k" tmpl)
  [[ -z $tmpl ]] && return 1
  bins=$(_ntap_get "$k" bins)
  for b in $bins; do command -v "$b" >/dev/null 2>&1 && { rbin=$b; break; }; done
  [[ -z $rbin ]] && return 1
  lead=${tmpl%% *}
  if [[ $rbin != "$lead" ]]; then
    if [[ $tmpl == *" "* ]]; then tmpl="$rbin ${tmpl#* }"; else tmpl=$rbin; fi
  fi
  [[ -n $perm ]] && { _ntap_flag_for "$(_ntap_get "$k" perms)" "$perm"; permflag=$NTAP_FLAG; }
  [[ -z $model ]] && model=$(_ntap_get "$k" defm)
  [[ -z $reasoning ]] && reasoning=$(_ntap_get "$k" defr)
  cmd=$tmpl
  if [[ -n $model ]]; then q=$(_ntap_shell_quote "$model"); cmd=${cmd//"{model}"/$q}; else cmd=${cmd//"{model}"/}; fi
  if [[ -n $reasoning ]]; then q=$(_ntap_shell_quote "$reasoning"); cmd=${cmd//"{reasoning}"/$q}; else cmd=${cmd//"{reasoning}"/}; fi
  cmd=${cmd//"{permission}"/$permflag}
  if [[ -n $sysprompt_file ]]; then
    if [[ $sysprompt_mode == replace ]]; then spflag=$(_ntap_get "$k" sysprompt_replace_file)
    else spflag=$(_ntap_get "$k" sysprompt_append_file); fi
    [[ -z $spflag ]] && return 1
    cmd="$cmd $(_ntap_shell_quote "$spflag") $(_ntap_shell_quote "$sysprompt_file")"
  fi
  while [[ $cmd == *"  "* ]]; do cmd=${cmd//  / }; done
  NTAP_CMD=${cmd% }
}

_ntap_build_for_launch() {
  local k=$1 model=$2 reasoning=$3 perm=$4 sysprompt_file="" sysprompt_mode=${NTAP_SESSION_PROMPT_MODE:-append}
  if _ntap_session_prompt_set; then
    if _ntap_prompt_supported "$k" "$sysprompt_mode"; then
      _ntap_prepare_session_prompt "$k" || { printf '  %scould not prepare session prompt%s\n' "$NTAP_ERR" "$NTAP_RST"; return 1; }
      sysprompt_file=$NTAP_PROMPT_FILE
    else
      printf '  %ssession prompt ignored:%s %s does not expose a supported %s system-prompt flag\n' "$NTAP_WARN" "$NTAP_RST" "$(_ntap_get "$k" label)" "$sysprompt_mode"
    fi
  fi
  _ntap_build "$k" "$model" "$reasoning" "$perm" "$sysprompt_file" "$sysprompt_mode"
}

_ntap_last() {
  NTAP_LASTKEY=""; NTAP_LASTMODEL=""; NTAP_LASTREASON=""; NTAP_LASTPERM=""
  local f=${NTAP_LAST_FILE:-${XDG_CONFIG_HOME:-$HOME/.config}/ntap/last}
  [[ -r $f ]] || return
  local d kk m r pm
  while IFS=$'\t' read -r d kk m r pm; do
    [[ $d == "$PWD" ]] && { NTAP_LASTKEY=$kk; NTAP_LASTMODEL=$m; NTAP_LASTREASON=$r; NTAP_LASTPERM=$pm; }
  done < "$f"
  [[ -n $NTAP_LASTKEY && -z $(_ntap_get "$NTAP_LASTKEY" tmpl) ]] && NTAP_LASTKEY=""
}

_ntap_save() {
  [[ $PWD == *$'\t'* ]] && return
  local f=${NTAP_LAST_FILE:-${XDG_CONFIG_HOME:-$HOME/.config}/ntap/last}
  mkdir -p "$(dirname "$f")" 2>/dev/null || return
  printf '%s\t%s\t%s\t%s\t%s\n' "$PWD" "$1" "$2" "$3" "$4" >> "$f"
  if [[ -f $f ]] && (( $(wc -l < "$f" 2>/dev/null) > 2000 )) && mkdir "$f.lock" 2>/dev/null; then
    tail -n 1000 "$f" > "$f.$$" 2>/dev/null && mv -f "$f.$$" "$f" 2>/dev/null
    rmdir "$f.lock" 2>/dev/null
  fi
}

_ntap_pickdir() {
  local start=$PWD ans nd2 i pwddisp nm hint
  local dirs=()
  [[ -n ${BASH_VERSION:-} ]] && shopt -s nullglob
  while true; do
    if [[ -n ${ZSH_VERSION:-} ]]; then
      eval 'dirs=( */(N) )'
    else
      dirs=( */ )
    fi
    pwddisp=${PWD/#$HOME/~}
    printf '\n  %s❯%s %sPick a directory%s  %s%s%s\n' "$NTAP_ACC" "$NTAP_RST" "$NTAP_BOLD" "$NTAP_RST" "$NTAP_DIM" "$pwddisp" "$NTAP_RST"
    if _ntap_new_mode; then
      hint="number opens folder · Enter selects this folder · back · new · parent folder · home folder · type a path (Tab completes)"
    else
      hint="number = open · enter = use here · b back · d new here · .. up · ~ home · path (Tab completes)"
    fi
    printf '  %s%s%s\n\n' "$NTAP_DIM" "$hint" "$NTAP_RST"
    for (( i = 0; i < ${#dirs[@]} && i < 40; i++ )); do
      nm=${dirs[i]%/}
      printf '    %s%s%s%s  %s/\n' "$NTAP_ACC" "$NTAP_BOLD" "$((i+1))" "$NTAP_RST" "$nm"
    done
    (( ${#dirs[@]} > 40 )) && printf '    %s… %s dirs total, type a name to jump%s\n' "$NTAP_DIM" "${#dirs[@]}" "$NTAP_RST"
    _ntap_read_path "  ❯ " || return 0
    ans=$NTAP_INPUT
    [[ -z $ans ]] && return 0
    if _ntap_is_back "$ans" || [[ $ans == q || $ans == quit ]]; then
      cd -- "$start" 2>/dev/null
      return 0
    elif _ntap_is_up "$ans"; then
      cd .. 2>/dev/null
    elif _ntap_is_home "$ans"; then
      cd ~ 2>/dev/null
    elif _ntap_is_newdir "$ans"; then
      _ntap_read_path "  new directory (in $pwddisp): " || continue
      nd2=$NTAP_INPUT
      [[ -n $nd2 ]] || continue
      if mkdir -p -- "$nd2" 2>/dev/null && cd -- "$nd2"; then printf '  %screated + now in%s  %s\n' "$NTAP_OK" "$NTAP_RST" "${PWD/#$HOME/~}"
      else printf '  %scould not create%s  %s\n' "$NTAP_ERR" "$NTAP_RST" "$nd2"; fi
    elif _ntap_is_uint "$ans" && (( ${#ans} <= 6 && ans >= 1 && ans <= ${#dirs[@]} )); then
      cd -- "${dirs[ans-1]}" 2>/dev/null
    else
      [[ $ans == "~"* ]] && ans=${ans/#\~/$HOME}
      if [[ -d $ans ]]; then cd -- "$ans" 2>/dev/null
      else printf '  %sno such directory%s  %s\n' "$NTAP_ERR" "$NTAP_RST" "$ans"; fi
    fi
  done
}

_ntap_run() {
  local keys=() labels=() kk b rb i pick k alabel model reasoning perm
  for kk in "${NTAP_ORDER[@]}"; do
    rb=""
    for b in $(_ntap_get "$kk" bins); do command -v "$b" >/dev/null 2>&1 && { rb=$b; break; }; done
    [[ -n $rb ]] && { keys+=("$kk"); labels+=("$(_ntap_get "$kk" label)"); }
  done
  (( ${#keys[@]} )) || return 0

  _ntap_last
  if [[ -n $NTAP_LASTKEY ]]; then
    while _ntap_build "$NTAP_LASTKEY" "$NTAP_LASTMODEL" "$NTAP_LASTREASON" "$NTAP_LASTPERM"; do
      local lastcmd=$NTAP_CMD rcmd="" b2 rbin2="" ans
      for b2 in $(_ntap_get "$NTAP_LASTKEY" bins); do command -v "$b2" >/dev/null 2>&1 && { rbin2=$b2; break; }; done
      [[ -n $(_ntap_get "$NTAP_LASTKEY" resume) && -n $rbin2 ]] && rcmd="$rbin2 $(_ntap_get "$NTAP_LASTKEY" resume)"
      printf '\n  %s❯%s %sNew terminal%s  %s%s%s\n' "$NTAP_ACC" "$NTAP_RST" "$NTAP_BOLD" "$NTAP_RST" "$NTAP_DIM" "${PWD/#$HOME/~}" "$NTAP_RST"
      printf '  last used here:  %s%s%s\n' "$NTAP_OK" "$lastcmd" "$NTAP_RST"
      if _ntap_new_mode; then
        [[ -n $rcmd ]] && printf '  %sEnter relaunches · resume · choose · shell%s\n' "$NTAP_DIM" "$NTAP_RST" || printf '  %sEnter relaunches · choose · shell%s\n' "$NTAP_DIM" "$NTAP_RST"
      else
        [[ -n $rcmd ]] && printf '  %senter = relaunch · r = resume session · c = choose · s = shell%s\n' "$NTAP_DIM" "$NTAP_RST" || printf '  %senter = relaunch · c = choose · s = shell%s\n' "$NTAP_DIM" "$NTAP_RST"
      fi
      printf '  %s❯%s ' "$NTAP_ACC" "$NTAP_RST"
      read -r ans || return 0
      if [[ -z $ans ]]; then
        _ntap_build_for_launch "$NTAP_LASTKEY" "$NTAP_LASTMODEL" "$NTAP_LASTREASON" "$NTAP_LASTPERM" || return 0
        printf '\n  %slaunching%s  %s\n\n' "$NTAP_OK" "$NTAP_RST" "$NTAP_CMD"
        eval "$NTAP_CMD"; _ntap_cleanup_session_prompt_temp; return
      fi
      if _ntap_is_resume "$ans" && [[ -n $rcmd ]]; then printf '\n  %sresuming%s  %s\n\n' "$NTAP_OK" "$NTAP_RST" "$rcmd"; eval "$rcmd"; return; fi
      _ntap_is_shell "$ans" && return 0
      break
    done
  fi

  while true; do
    printf '\n  %s❯%s %sNew terminal%s  %s%s%s\n' "$NTAP_ACC" "$NTAP_RST" "$NTAP_BOLD" "$NTAP_RST" "$NTAP_DIM" "${PWD/#$HOME/~}" "$NTAP_RST"
    if _ntap_new_mode; then printf '  %stype a number to choose an agent · Enter opens a normal shell%s\n' "$NTAP_DIM" "$NTAP_RST"
    else printf '  %snumber to choose an agent · enter = plain shell%s\n' "$NTAP_DIM" "$NTAP_RST"; fi
    printf '\n'
    for (( i = 0; i < ${#keys[@]}; i++ )); do printf '    %s%s%s%s  %s\n' "$NTAP_ACC" "$NTAP_BOLD" "$((i+1))" "$NTAP_RST" "${labels[i]}"; done
    printf '\n'
    if _ntap_new_mode; then printf '    %s%spath%s  choose folder      %s%snew%s  create folder\n' "$NTAP_ACC" "$NTAP_BOLD" "$NTAP_RST" "$NTAP_ACC" "$NTAP_BOLD" "$NTAP_RST"
    else printf '    %s%sp%s  pick a directory      %s%sd%s  new directory\n' "$NTAP_ACC" "$NTAP_BOLD" "$NTAP_RST" "$NTAP_ACC" "$NTAP_BOLD" "$NTAP_RST"; fi
    printf '  %s❯%s ' "$NTAP_ACC" "$NTAP_RST"
    read -r pick || return 0
    if [[ -z $pick ]] || _ntap_is_shell "$pick"; then return 0; fi
    if _ntap_is_pathpick "$pick"; then _ntap_pickdir; continue; fi
    if _ntap_is_newdir "$pick"; then
      local pwddisp=${PWD/#$HOME/~} nd
      _ntap_read_path "  new directory (created under $pwddisp): " || continue
      nd=$NTAP_INPUT
      [[ -n $nd ]] || continue
      if mkdir -p -- "$nd" 2>/dev/null && cd -- "$nd"; then printf '  %snow in%s  %s\n' "$NTAP_OK" "$NTAP_RST" "${PWD/#$HOME/~}"
      else printf '  %scould not create%s  %s\n' "$NTAP_ERR" "$NTAP_RST" "$nd"; fi
      continue
    fi
    if ! _ntap_is_uint "$pick" || (( ${#pick} > 6 || pick < 1 || pick > ${#keys[@]} )); then
      if _ntap_new_mode; then printf '  %s?%s  type 1-%s, path, new, or Enter for a normal shell\n' "$NTAP_WARN" "$NTAP_RST" "${#keys[@]}"
      else printf '  %s?%s  enter 1-%s, p/d for a directory, or Enter for a shell\n' "$NTAP_WARN" "$NTAP_RST" "${#keys[@]}"; fi
      continue
    fi
    k=${keys[pick-1]}; alabel=${labels[pick-1]}
    model=$(_ntap_get "$k" defm); reasoning=$(_ntap_get "$k" defr); perm=$(_ntap_get "$k" defp)
    local steps=() si=0 redo=0 quit=0 reply tmpl
    tmpl=$(_ntap_get "$k" tmpl)
    [[ $tmpl == *"{model}"* && -n $(_ntap_get "$k" models) ]] && steps+=("model")
    [[ $tmpl == *"{reasoning}"* && -n $(_ntap_get "$k" reason) ]] && steps+=("reason")
    [[ $tmpl == *"{permission}"* && -n $(_ntap_get "$k" perms) ]] && steps+=("perm")
    { _ntap_prompt_supported "$k" append || _ntap_prompt_supported "$k" replace; } && steps+=("sysprompt")
    while (( si < ${#steps[@]} )); do
      case ${steps[si]} in
        model) _ntap_pick "$alabel  ›  model" "$(_ntap_get "$k" models)" "$(_ntap_get "$k" defm)" ;;
        reason) _ntap_pick "$alabel  ›  reasoning / effort" "$(_ntap_get "$k" reason)" "$(_ntap_get "$k" defr)" ;;
        perm) _ntap_pick "$alabel  ›  permission" "$(_ntap_get "$k" perms)" "$(_ntap_get "$k" defp)" ;;
        sysprompt) _ntap_pick_session_prompt "$alabel" "$k" ;;
      esac
      if [[ $NTAP_REPLY == __NTAP_QUIT__ ]]; then quit=1; break; fi
      if [[ $NTAP_REPLY == __NTAP_BACK__ ]]; then
        (( si == 0 )) && { redo=1; break; }
        ((si--)); continue
      fi
      case ${steps[si]} in
        model) model=$NTAP_REPLY ;;
        reason) reasoning=$NTAP_REPLY ;;
        perm) perm=$NTAP_REPLY ;;
      esac
      ((si++))
    done
    (( quit )) && return 0
    (( redo )) && continue
    _ntap_build_for_launch "$k" "$model" "$reasoning" "$perm" || { printf '  %scould not launch %s%s\n' "$NTAP_ERR" "$alabel" "$NTAP_RST"; continue; }
    _ntap_save "$k" "$model" "$reasoning" "$perm"
    printf '\n  %slaunching%s  %s\n\n' "$NTAP_OK" "$NTAP_RST" "$NTAP_CMD"
    eval "$NTAP_CMD"
    _ntap_cleanup_session_prompt_temp
    return
  done
}

_ntap_cleanup_runtime() {
  local v
  for v in $(set | sed -n 's/^\(NTAP_[A-Za-z0-9_][A-Za-z0-9_]*\)=.*/\1/p'); do
    case $v in
      NTAP_DONE|NTAP_MODE|NTAP_TERMINAL_MODE|NTAP_LAST_FILE) ;;
      *) unset "$v" 2>/dev/null ;;
    esac
  done
}

_ntap_init_colors
_ntap_run
_ntap_cleanup_session_prompt_temp
_ntap_cleanup_runtime
unset -f _ntap_run _ntap_pick _ntap_pick_session_prompt _ntap_flag_for _ntap_build _ntap_build_for_launch _ntap_last _ntap_save _ntap_pickdir _ntap_new_mode _ntap_is_back _ntap_is_shell _ntap_is_resume _ntap_is_choose _ntap_is_pathpick _ntap_is_newdir _ntap_is_up _ntap_is_home _ntap_is_sysprompt _ntap_is_full_sysprompt _ntap_is_clear _ntap_read_path _ntap_session_prompt_set _ntap_prompt_supported _ntap_cleanup_session_prompt_temp _ntap_resolve_prompt_file _ntap_set_session_prompt _ntap_prepare_session_prompt _ntap_init_colors _ntap_keyvar _ntap_get _ntap_shell_quote _ntap_is_uint _ntap_cleanup_runtime 2>/dev/null
