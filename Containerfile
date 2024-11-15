FROM quay.io/fedora/fedora:41

ARG TARGETARCH

RUN dnf check-update && \
  dnf install -y \
  bat \
  bc \
  bzip2 \
  chpasswd \
  curl \
  diff \
  diffutils \
  entr \
  eza \
  find \
  findmnt \
  fzf \
  gh \
  git \
  git-delta \
  gnupg2 \
  gpg \
  hostname \
  httpie \
  jq \
  just \
  less \
  litecli \
  lsof \
  make \
  man \
  mount \
  mycli \
  ncdu \
  neovim \
  openssl \
  passwd \
  pgcli \
  pigz \
  pinentry \
  ping \
  prettyping \
  ps \
  python-pip \
  python3-pip \
  rcm \
  ripgrep \
  rsync \
  script \
  ssh \
  sudo \
  tig \
  time \
  tldr \
  tmux \
  tree \
  umount \
  unzip \
  useradd \
  wc \
  wget \
  which \
  xauth \
  zip \
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
