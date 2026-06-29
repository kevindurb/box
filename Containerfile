FROM quay.io/fedora/fedora:44

ADD https://pkgs.tailscale.com/stable/fedora/tailscale.repo /etc/yum.repos.d/tailscale.repo

RUN dnf5 install --assumeyes \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
    && dnf5 install --assumeyes dnf5-plugins \
    && dnf update -y && dnf install -y \
    @development-tools \
    curl \
    diff \
    ffmpeg \
    find \
    findmnt \
    fish \
    git \
    gnupg2 \
    gpg \
    pv \
    python-pip \
    python3-pip \
    rsync \
    sudo \
    tailscale \
    tini \
    util-linux-user \
    wget \
    wireguard-tools \
    wl-clipboard \
    && dnf clean all

ARG USERNAME=kevindurb
ARG USER_UID=1000
ARG USER_GID=1000
ARG HOME=/home/$USERNAME

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/fish $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER $USERNAME
WORKDIR $HOME

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
