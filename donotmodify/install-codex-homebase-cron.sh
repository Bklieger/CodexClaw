#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WATCHER_SCRIPT="${SCRIPT_DIR}/codex-homebase-continue.sh"
CRON_COMMAND="bash ${WATCHER_SCRIPT}"
CRON_SCHEDULE="${CRON_SCHEDULE:-0 */3 * * *}"
TMP_CRON="$(mktemp)"

if [[ ! -f "${WATCHER_SCRIPT}" ]]; then
  echo "Watcher script is missing: ${WATCHER_SCRIPT}" >&2
  exit 1
fi

if crontab -l > "${TMP_CRON}" 2>/dev/null; then
  :
else
  : > "${TMP_CRON}"
fi

grep -Fv "${WATCHER_SCRIPT}" "${TMP_CRON}" > "${TMP_CRON}.next" || true
mv "${TMP_CRON}.next" "${TMP_CRON}"

{
  echo "SHELL=/bin/bash"
  echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
  echo "HOME=${HOME}"
} > "${TMP_CRON}.env"

grep -Ev '^(SHELL|PATH|HOME)=' "${TMP_CRON}" > "${TMP_CRON}.body" || true

cat "${TMP_CRON}.env" "${TMP_CRON}.body" > "${TMP_CRON}.merged"
printf '%s %s\n' "${CRON_SCHEDULE}" "${CRON_COMMAND}" >> "${TMP_CRON}.merged"

crontab "${TMP_CRON}.merged"
echo "Installed cron entry:"
printf '%s %s\n' "${CRON_SCHEDULE}" "${CRON_COMMAND}"

rm -f "${TMP_CRON}" "${TMP_CRON}.env" "${TMP_CRON}.body" "${TMP_CRON}.merged"
