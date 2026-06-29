#!/bin/bash

if [ ! -f ".bashrc" ]; then
    echo "First boot detected. Populating home directory..."
    cp -r /etc/skel/. .
fi

mkdir -p .tailscale

tailscaled \
    --tun=userspace-networking \
    --statedir=.tailscale \
    --socket=.tailscale/tailscaled.sock \
    --socks5-server=localhost:1055 \
    --outbound-http-proxy-listen=localhost:1055 &

sleep 2

if [ -n "$TS_AUTHKEY" ]; then
    echo "Authenticating with Tailscale..."
    tailscale --socket=.tailscale/tailscaled.sock up --authkey="${TS_AUTHKEY}" --ssh --accept-dns=false
else
    echo "Warning: TS_AUTHKEY not set. Tailscale standing by offline."
fi

exec sleep infinity
