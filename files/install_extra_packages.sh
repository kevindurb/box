#! /bin/bash
set -eux -o pipefail

dnf copr enable atim/lazygit -y
dnf copr enable atim/starship -y

dnf update -y
grep -v '^#' /tmp/extra-packages | xargs dnf install -y
dnf clean all
