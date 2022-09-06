#!/usr/bin/env bash
git clone --quiet https://github.com/lukevella/rallly.git /tmp/rallly
pushd /tmp/rallly > /dev/null || exit
version=$(git rev-list --count --first-parent HEAD)
popd > /dev/null || exit
rm -rf /tmp/rallly
printf "1.0.%d" "${version}"
