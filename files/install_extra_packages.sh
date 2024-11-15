#! /bin/bash
set -eux -o pipefail

sudo dnf copr enable atim/lazygit -y
sudo dnf copr enable atim/starship -y

dnf update -y
grep -v '^#' /tmp/extra-packages | xargs dnf install -y
dnf clean all
