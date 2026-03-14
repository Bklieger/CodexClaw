#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOMEBASE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CODEX_BIN="$(command -v codex)"
LOG_DIR="${HOMEBASE_DIR}/logs"
START_TS="$(date -u '+%Y%m%dT%H%M%SZ')"
RUN_LOG="${LOG_DIR}/codex-run-${START_TS}.log"
PROMPT="Start from scratch in ${HOMEBASE_DIR}. First inspect the newest prior run log in ${LOG_DIR} to determine what was being worked on last. Then explore the memory system and any memory files that Codex has constructed in ${HOMEBASE_DIR}. Continue the most relevant unfinished work you find. If prior context is missing or incomplete, create a new memory file in ${HOMEBASE_DIR} capturing the current objective, what you discovered, and the next actions."

mkdir -p "${HOMEBASE_DIR}" "${LOG_DIR}"

if [[ -z "${CODEX_BIN}" ]]; then
  printf '%s codex binary not found on PATH\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" >> "${RUN_LOG}"
  exit 1
fi

if pgrep -af "${CODEX_BIN}" >/dev/null; then
  exit 0
fi

cd "${HOMEBASE_DIR}"

printf '%s starting codex continue job\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" >> "${RUN_LOG}"

nohup bash -lc '
  set -euo pipefail
  "'"${CODEX_BIN}"'" exec --skip-git-repo-check "'"${PROMPT}"'" >> "'"${RUN_LOG}"'" 2>&1
' >> "${RUN_LOG}" 2>&1 &
