FROM quay.io/fedora/fedora:41

ARG TARGETARCH

RUN dnf check-update && \
  dnf install -y \
  autojump-zsh \
  bat \
  bc \
  diffutils \
  entr \
  eza \
  fzf \
  gh \
  git \
  git-delta \
  gnupg2 \
  httpie \
  jq \
  just \
  less \
  litecli \
  lsof \
  make \
  man \
  mycli \
  ncdu \
  neovim \
  openssl \
  pgcli \
  prettyping \
  python-pip \
  python3-pip \
  rcm \
  ripgrep \
  tig \
  time \
  tldr \
  tmux \
  wget \
  which \
  zsh && \
  dnf clean all

COPY ./files/host-spawn-$TARGETARCH /usr/bin/host-spawn

RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/distrobox && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/xdg-open && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update

ENV SHELL=/usr/bin/zsh
ENTRYPOINT ["/usr/bin/zsh"]
