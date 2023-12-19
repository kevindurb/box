FROM docker.io/library/debian:12

COPY ./files/extra-packages /tmp

RUN apt update && \
  apt upgrade && \
  grep -v '^#' /tmp/extra-packages | xargs apt install --yes && \
  rm -rf /var/lib/apt/lists/*

RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/distrobox && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/xdg-open && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update

RUN useradd -ms /bin/bash  linuxbrew
RUN echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER linuxbrew
COPY ./files/install_homebrew.sh /tmp
RUN bash /tmp/install_homebrew.sh

COPY ./files/Brewfile /tmp
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
  brew bundle install --file /tmp/Brewfile && \
  brew cleanup --prune=all
