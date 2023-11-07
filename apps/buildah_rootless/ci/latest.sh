#!/usr/bin/env bash
version="$(grep FROM './apps/buildah_rootless/Dockerfile' | cut -d ':' -f2)"
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"