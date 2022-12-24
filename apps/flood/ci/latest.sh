#!/usr/bin/env bash
version=$(curl -sX GET "https://api.github.com/repos/jesec/flood/releases" | jq --raw-output '.[0].tag_name' 2>/dev/null)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
