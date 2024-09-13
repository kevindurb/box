FROM registry.fedoraproject.org/fedora:40

COPY ./files/extra-packages /tmp

RUN dnf check-update && \
  grep -v '^#' /tmp/extra-packages | xargs dnf install -y && \
  dnf clean all

RUN groupadd -g 1000 dev
RUN groupadd sudo
RUN useradd -m -d /home/dev -s /usr/bin/zsh -g 1000 -G sudo -u 1000 dev 

WORKDIR /home/dev
USER dev

RUN mkdir .ssh
COPY ./files/authorized_keys .ssh/authorized_keys

EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd"]
CMD ["-D"]
