#!/usr/bin/env bash
git clone --quiet https://github.com/tvheadend/tvheadend.git /tmp/tvheadend
pushd /tmp/tvheadend > /dev/null || exit
version=$(git rev-list --count --first-parent HEAD)
popd > /dev/null || exit
rm -rf /tmp/tvheadend
printf "4.3.%d" "${version}"
