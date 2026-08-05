# Latest models

Dated snapshot of recent model releases behind the picker menus, including open-weight models for people running local setups. Last verified: 2026-08-05.

To refresh: re-check recent releases (r/LocalLLaMA, llm-stats.com, or a 30-day research pass), update this file, then update the menu rows in `terminal-agent-picker.sh`.

## Hosted frontier

| Model | ID / alias | Released | Notes |
|---|---|---|---|
| Claude Fable 5 | `fable` (Claude Code), `claude-fable-5` | 2026-06-09 | Highest capability tier, $10/$50 per MTok |
| Claude Opus 5 | `opus` (Claude Code), `claude-opus-5` | 2026-07-24 | Near-Fable performance at half the price ($5/$25), 1M context default, 128K output. Leads Artificial Analysis Intelligence Index as of Aug 2026 |
| Claude Sonnet 5 | `sonnet` (Claude Code), `claude-sonnet-5` | 2026 | Daily driver, 1M context. Intro pricing $2/$10 through 2026-08-31, then $3/$15 |
| GPT-5.6 Sol / Terra / Luna | `gpt-5.6-sol` etc. | 2026-07-09 | Codex CLI default is Sol at medium effort. Sol/Terra support `ultra`, Luna caps at `max` |
| Gemini 3.1 Pro | `gemini-3.1-pro-preview` | — | Latest Pro in Gemini CLI |
| DeepSeek V4-Flash 0731 | API | 2026-07-31 | Price-performance pick, $0.14/$0.28 per MTok |
| Meta Muse Spark 1.1 | hosted | 2026-07 | Adds a paid developer tier |

## Open-weight / local

Run via Ollama, LM Studio, llama.cpp, or vLLM. Larger MoE models need multi-GPU or server hardware.

| Model | Weights | Notes |
|---|---|---|
| Kimi K3 (Moonshot) | 2026-07-27 | 2.8T-param MoE, largest open-weight model announced to date |
| Qwen 3.8 Max (Alibaba) | 2026-08 | Alibaba's largest and most capable Qwen, ~2.4T params per launch coverage |
| Kimi K2.6 (Moonshot) | earlier 2026 | Best local coding pick right now (58.6 SWE-Bench Pro), 1T MoE with 32B active |
| GLM-5.1 (Zhipu) | earlier 2026 | Top open model for coding and agentic work alongside Kimi K2.6 |
| DeepSeek V4 Pro | earlier 2026 | Frontier open MoE, needs dual-GPU or server class hardware |
| Qwen3 8B (Alibaba) | earlier 2026 | The 8 GB-VRAM tier pick, ~5 GB VRAM |
| Gemma 4 26B A4B (Google) | earlier 2026 | Local coding without API calls, runs on one high-memory GPU |
| Llama 3.3 70B (Meta) | 2025 | Still a common local baseline |
