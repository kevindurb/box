FROM quay.io/toolbx-images/fedora-toolbox:40
ARG TARGETARCH

COPY ./files/extra-packages /tmp

RUN dnf check-update && \
  grep -v '^#' /tmp/extra-packages | xargs dnf install -y && \
  dnf clean all

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
ENTRYPOINT ["/usr/bin/zsh"]
