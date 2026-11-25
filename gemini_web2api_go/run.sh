#!/bin/sh
set -eu
umask 077
ADMIN_TOKEN="$(jq -r '.admin_token // ""' /data/options.json)"
if [ "${#ADMIN_TOKEN}" -lt 16 ]; then
  echo "Set admin_token to at least 16 characters in Configuration."
  exit 1
fi
export ADMIN_TOKEN
MCP_KEY="$(jq -r '.mcp_api_key // ""' /data/options.json)"
MCP_SECRET="$(jq -r '.mcp_secret // ""' /data/options.json)"
mkdir -p /tmp/mcp-conf
rm -f /tmp/mcp-conf/default.conf
if [ -n "$MCP_KEY" ]; then
  if printf '%s' "$MCP_KEY" | grep -Eq '^sk-gemini-[A-Za-z0-9_-]+$' && printf '%s' "$MCP_SECRET" | grep -Eq '^[A-Za-z0-9_-]{32,128}$'; then
    cat > /tmp/mcp-conf/default.conf <<EOF
server {
  listen 8084;
  location = /mcp/$MCP_SECRET {
    proxy_pass http://127.0.0.1:8083/mcp;
    proxy_http_version 1.1;
    proxy_set_header Authorization "Bearer $MCP_KEY";
    proxy_set_header Host 127.0.0.1:8083;
    proxy_set_header Connection "";
    proxy_buffering off;
    proxy_read_timeout 600s;
    proxy_intercept_errors on;
    error_page 401 403 =502 /mcp-auth-error;
  }
  location = /mcp-auth-error { internal; return 502; }
  location / { return 404; }
}
EOF
    echo "Internal MCP proxy enabled on port 8084."
  else
    echo "MCP proxy disabled: invalid API key or secret (32-128 URL-safe characters required)."
  fi
fi

gemini-web2api --port 8083 --db /data/gemini.db &
PID=$!
nginx -g 'daemon off;' &
PROXY=$!
trap 'kill "$PID" "$PROXY" 2>/dev/null || true; exit 0' TERM INT
while kill -0 "$PID" 2>/dev/null && kill -0 "$PROXY" 2>/dev/null; do sleep 2; done
kill "$PID" "$PROXY" 2>/dev/null || true
exit 1
