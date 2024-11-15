FROM quay.io/fedora/fedora:41

ARG TARGETARCH

COPY ./files/kubernetes.repo /etc/yum.repos.d/kubernetes.repo

COPY ./files/extra-packages /tmp
COPY ./files/install_extra_packages.sh /tmp

RUN sh /tmp/install_extra_packages.sh

COPY ./files/host-spawn-$TARGETARCH /usr/bin/host-spawn

RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/distrobox && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/xdg-open && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update

COPY ./files/install_chezmoi.sh /tmp/install_chezmoi.sh
RUN sh /tmp/install_chezmoi.sh -b /usr/local/bin

ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]
