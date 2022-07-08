#!/usr/bin/env bash
version=$(curl -sX GET "https://api.github.com/repos/prodrigestivill/go-cron/releases/latest" | jq --raw-output '.tag_name')
version="${version%%_*}"
version="${version%%-*}"
printf "%s" "${version}"
