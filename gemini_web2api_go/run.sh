#!/bin/sh
set -eu
umask 077
ADMIN_TOKEN="$(jq -r '.admin_token // ""' /data/options.json)"
if [ "${#ADMIN_TOKEN}" -lt 16 ]; then
  echo "Set admin_token to at least 16 characters in Configuration."
  exit 1
fi
export ADMIN_TOKEN
gemini-web2api --port 8083 --db /data/gemini.db &
PID=$!
nginx -g 'daemon off;' &
PROXY=$!
trap 'kill "$PID" "$PROXY" 2>/dev/null || true; exit 0' TERM INT
while kill -0 "$PID" 2>/dev/null && kill -0 "$PROXY" 2>/dev/null; do sleep 2; done
kill "$PID" "$PROXY" 2>/dev/null || true
exit 1
