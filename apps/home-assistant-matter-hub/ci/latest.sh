#!/usr/bin/env bash
channel=$1
version=$(curl -sX GET "https://registry.npmjs.org/home-assistant-matter-hub" | jq --raw-output '."dist-tags".latest' 2>/dev/null)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
