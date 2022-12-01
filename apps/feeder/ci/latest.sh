#!/usr/bin/env bash
version="v0.0.1"
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"