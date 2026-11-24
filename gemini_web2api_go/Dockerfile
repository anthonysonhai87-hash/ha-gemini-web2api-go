FROM ghcr.io/zexadev/gemini-web2api-go:latest AS upstream
FROM alpine:3.22
RUN apk add --no-cache ca-certificates jq nginx
COPY --from=upstream /app/gemini-web2api /usr/local/bin/gemini-web2api
COPY run.sh /run.sh
COPY nginx.conf /etc/nginx/nginx.conf
RUN chmod 755 /run.sh
ENTRYPOINT ["/run.sh"]
