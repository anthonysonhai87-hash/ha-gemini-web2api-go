# 1.0.4
- Restore v1.0.1 wrapper behavior and remove internal MCP proxy.
- Preserve database path and LAN API configuration.

# 1.0.3
- Fix malformed startup shell script.

# 1.0.2
- Optional internal secret-path MCP reverse proxy with bearer authentication upstream.
- No host port publication for MCP; existing API and database unchanged.
- Experimental, runtime compatibility not yet verified.

# 1.0.1
- Forward WebSocket upgrade headers through Ingress.

# 1.0.0
- Experimental amd64 wrapper with Ingress and persistent database.
