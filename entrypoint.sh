#!/bin/bash

STATE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/tailscale"
RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME/.local/run}/tailscale"
SOCKET="$RUNTIME_DIR/tailscaled.sock"

if [ ! -f "$HOME/.bashrc" ]; then
    echo "First boot detected. Populating home directory..."
    cp -r /etc/skel/. "$HOME"
fi

mkdir -p "$STATE_DIR" "$RUNTIME_DIR"

tailscaled \
    --tun=userspace-networking \
    --statedir="$STATE_DIR" \
    --socket="$SOCKET" \
    --socks5-server=localhost:1055 \
    --outbound-http-proxy-listen=localhost:1055 &

for _ in $(seq 1 100); do
    tailscale --socket="$SOCKET" status --json >/dev/null 2>&1 && break
    sleep 0.1
done

if [ -n "$TS_AUTHKEY" ]; then
    echo "Authenticating with Tailscale..."
    tailscale --socket="$SOCKET" up --authkey="$TS_AUTHKEY" --ssh --accept-dns=false
else
    echo "Warning: TS_AUTHKEY not set. Tailscale standing by offline."
fi

exec sleep infinity
