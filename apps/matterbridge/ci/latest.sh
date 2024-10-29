#!/usr/bin/env bash
channel=$1
version=$(curl -sX GET "https://registry.npmjs.org/matterbridge" | jq --raw-output '."dist-tags".latest' 2>/dev/null)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
