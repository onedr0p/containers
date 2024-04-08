#!/usr/bin/env bash
#version=$(curl -H "Accept: application/vnd.github+json" https://api.github.com/repos/Casvt/kapowarr/releases | jq -r 'sort_by(.published_at) | reverse | .[].name' | head -n 1)
# We don't have regular releases yet
version=$(curl -s https://api.github.com/repos/Casvt/kapowarr/commits | jq -r 'sort_by(.published_at) | .[].sha' | head -n 1)
printf "%s" "${version}"
