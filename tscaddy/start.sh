#!/bin/sh

function finish {
    echo "Logging out of Tailscale network..."
    tailscale logout
    echo "Done."
    exit 0
}

trap finish SIGHUP SIGINT SIGTERM

echo "Starting Tailscale daemon"
# TODO: Why is --statedir required although --state=mem: is used? Bug or misunderstanding?
tailscaled --tun=userspace-networking --statedir=/var/lib/tailscale --state=mem: &
TAILSCALED_PID=$!

until tailscale up --authkey="${TAILSCALE_AUTH_KEY}" --hostname="${TAILSCALE_HOSTNAME}" --ssh; do
    sleep 0.1
done

echo "Tailscale connected"
tailscale status

echo "Starting Caddy"
caddy reverse-proxy --from ${TAILSCALE_HOSTNAME}.${TAILSCALE_DOMAIN} --to ${TARGET_SERVICE}:${TARGET_PORT} &
CADDY_PID=$!

wait $TAILSCALED_PID

