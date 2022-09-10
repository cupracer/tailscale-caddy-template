FROM tailscale/tailscale

RUN apk update && apk add caddy

COPY start.sh /start.sh

RUN chmod +x /start.sh

RUN mkdir -p /var/lib/tailscale

CMD "/start.sh"

