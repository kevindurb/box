FROM ghcr.io/archlinux/archlinux:base-20240520.0.237425
ARG TARGETARCH

COPY ./files/extra-packages /tmp

RUN pacman-key --init && \
  grep -v '^#' /tmp/extra-packages | pacman -Sy --needed --noconfirm - && \
  yes | pacman -Scc && \
  rm -r /etc/pacman.d/gnupg

RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/distrobox && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/xdg-open

COPY ./files/host-spawn-$TARGETARCH /usr/bin/host-spawn

ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]
