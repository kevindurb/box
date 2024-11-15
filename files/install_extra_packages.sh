#! /bin/bash
set -eux -o pipefail

dnf update -y
grep -v '^#' /tmp/extra-packages | xargs dnf install -y
dnf clean all
