#!/usr/bin/env bash
version="$(grep ansible './apps/ansible/requirements.txt' | cut -d '=' -f3)"
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"