#! /bin/bash
set -eux -o pipefail

grep -v '^#' /tmp/extra-copr-repos | xargs dnf copr enable -y
dnf update -y
grep -v '^#' /tmp/extra-packages | xargs dnf install -y
dnf clean all
