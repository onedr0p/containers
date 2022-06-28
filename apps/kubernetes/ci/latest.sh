#!/usr/bin/env bash
version=$(curl -L -s https://dl.k8s.io/release/stable.txt)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
