FROM docker.io/library/debian:12
ARG TARGETARCH

COPY ./files/extra-packages /tmp

RUN apt update && \
  grep -v '^#' /tmp/extra-packages | xargs apt install --yes && \
  rm -rf /var/lib/apt/lists/*

RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/distrobox && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/xdg-open && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update

COPY ./files/host-spawn-$TARGETARCH /usr/bin/host-spawn

COPY ./files/install_starship.sh /tmp/install_starship.sh
RUN sh /tmp/install_starship.sh --yes

ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/bin/zsh"]
