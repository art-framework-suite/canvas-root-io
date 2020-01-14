#!/bin/bash
########################################################################
# tarit.sh
#
# Produce a tarball.
########################################################################
set -e
script_dir="$(dirname $(realpath "${BASH_SOURCE[0]}"))"
dirname="$(basename "${script_dir}")"
parent="$(dirname "${script_dir}")"
tarball="${1:-${dirname}}.tar.bz2"
tar -C "${parent}" \
    --exclude .gitignore --exclude lib --exclude \*~ --exclude \*.cpp\* \
    --exclude \*.log --exclude \*.out --exclude \*.err --exclude "${tarball}" \
    -cvf "${tarball}" "${dirname}"
echo "Created $(realpath "$(pwd)/${tarball}")"
