FROM scratch as host-spawn-amd64
# renovate: datasource=github-tags depName=host-spawn packageName=1player/host-spawn
ARG HOST_SPAWN_VERSION=v1.6.0
ARG MARCH=x86_64
ADD https://github.com/1player/host-spawn/releases/download/${HOST_SPAWN_VERSION}/host-spawn-${MARCH} /host-spawn

FROM scratch as host-spawn-arm64
# renovate: datasource=github-tags depName=host-spawn packageName=1player/host-spawn
ARG HOST_SPAWN_VERSION=v1.6.0
ARG MARCH=aarch64
ADD https://github.com/1player/host-spawn/releases/download/${HOST_SPAWN_VERSION}/host-spawn-${MARCH} /host-spawn

FROM quay.io/fedora/fedora:42
ARG TARGETARCH

WORKDIR /tmp
COPY ./files/repos/kubernetes.repo /etc/yum.repos.d/kubernetes.repo
COPY ./files/extra-packages ./
COPY ./files/install_extra_packages.sh ./
RUN sh ./install_extra_packages.sh &&\
  rm ./extra-packages ./install_extra_packages.sh

COPY --from=host-spawn-${TARGETARCH} /host-spawn /usr/bin/host-spawn

RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/distrobox && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/xdg-open && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update

WORKDIR /
ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]
