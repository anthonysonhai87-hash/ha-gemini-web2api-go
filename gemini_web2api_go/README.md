# Gemini Web2API Go (experimental)
Upstream: https://github.com/zexadev/gemini-web2api-go
Set a unique admin_token of at least 16 characters before starting. Open Web UI via Ingress. Database is stored in /data. Optional host port 8083 is disabled by default; enable only if necessary on a trusted LAN. OpenAI-compatible API is /v1. Do not publish credentials or expose the admin port publicly. This wrapper uses the upstream latest image and has not been tested on HAOS. Upstream features may change.

## Optional internal MCP proxy (experimental)
Set mcp_api_key to your Gemini API key and mcp_secret to a random 32-128 character URL-safe secret. Restart. Port 8084 is not published to the host. In Home Assistant MCP Client use http://<addon-internal-hostname>:8084/mcp/<mcp_secret>. The secret URL is a credential; do not share it or expose it through Cloudflare. All upstream MCP tools may be exposed. No OAuth credentials are needed if the upstream connection succeeds. This integration has not been runtime tested. The existing /data database is unchanged.
