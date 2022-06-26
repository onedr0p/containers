#!/usr/bin/env bash
version=$(curl -sX GET https://api.github.com/repos/recyclarr/recyclarr/releases/latest | jq --raw-output '.name')
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
