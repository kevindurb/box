FROM scratch as host-spawn-amd64
ARG HOST_SPAWN_VERSION=1.6.0
ADD https://github.com/1player/host-spawn/releases/download/v${HOST_SPAWN_VERSION}/host-spawn-x86_64 /host-spawn

FROM scratch as host-spawn-arm64
ARG HOST_SPAWN_VERSION=1.6.0
ADD https://github.com/1player/host-spawn/releases/download/v${HOST_SPAWN_VERSION}/host-spawn-aarch64 /host-spawn

FROM docker.io/library/alpine as k9s
ARG TARGETARCH
ARG K9S_VERSION=0.32.7
ADD https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_${TARGETARCH}.tar.gz .
RUN tar -xzf ./k9s_Linux_${TARGETARCH}.tar.gz k9s

FROM docker.io/library/alpine as chezmoi
ARG TARGETARCH
ARG CHEZMOI_VERSION=2.54.0
ADD https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}/chezmoi_${CHEZMOI_VERSION}_linux_${TARGETARCH}.tar.gz .
RUN tar -xzf ./chezmoi_${CHEZMOI_VERSION}_linux_${TARGETARCH}.tar.gz chezmoi

FROM docker.io/library/alpine as kubeseal
ARG TARGETARCH
ARG KUBESEAL_VERSION=0.27.2
ADD https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-${TARGETARCH}.tar.gz .
RUN tar -xzf ./kubeseal-${KUBESEAL_VERSION}-linux-${TARGETARCH}.tar.gz kubeseal

FROM quay.io/fedora/fedora:41
ARG TARGETARCH

WORKDIR /tmp
COPY ./files/repos/kubernetes.repo /etc/yum.repos.d/kubernetes.repo
COPY ./files/extra-packages ./
COPY ./files/install_extra_packages.sh ./
RUN sh ./install_extra_packages.sh &&\
  rm ./extra-packages ./install_extra_packages.sh

COPY --from=host-spawn-${TARGETARCH} /host-spawn /usr/bin/host-spawn
COPY --from=k9s /k9s /usr/local/bin/k9s
COPY --from=chezmoi /chezmoi /usr/local/bin/chezmoi
COPY --from=kubeseal /kubeseal /usr/local/bin/kubeseal

RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/distrobox && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/xdg-open && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update

ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]
