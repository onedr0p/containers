#!/usr/bin/env bash
#version=$(curl -H "Accept: application/vnd.github+json" https://api.github.com/repos/Casvt/kapowarr/releases | jq -r 'sort_by(.published_at) | reverse | .[].name' | head -n 1)
# We don't have regular releases yet
version=$(curl -s https://api.github.com/repos/Casvt/kapowarr/releases/latest | jq --raw-output '.tag_name')
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
