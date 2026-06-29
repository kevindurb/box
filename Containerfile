FROM quay.io/fedora/fedora:44

ADD https://pkgs.tailscale.com/stable/fedora/tailscale.repo /etc/yum.repos.d/tailscale.repo

RUN dnf install -y tailscale \
    && dnf clean all

ARG USERNAME=kevindurb
ARG USER_UID=1000
ARG USER_GID=1000
ARG HOME=/home/$USERNAME

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER $USERNAME
WORKDIR $HOME

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
