#!/usr/bin/env bash
version=$(curl -sX GET "https://registry.npmjs.org/zigbee2mqtt" | jq --raw-output '."dist-tags".latest' 2>/dev/null)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
