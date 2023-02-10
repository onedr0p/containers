#!/usr/bin/env bash
git clone --quiet https://github.com/udp-redux/udp-broadcast-relay-redux.git /tmp/udp-broadcast-relay-redux
pushd /tmp/udp-broadcast-relay-redux > /dev/null || exit
version=$(git rev-list --count --first-parent HEAD)
popd > /dev/null || exit
rm -rf /tmp/udp-broadcast-relay-redux
printf "1.0.%d" "${version}"
