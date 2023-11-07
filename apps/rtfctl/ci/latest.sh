#!/usr/bin/env bash
version="$(curl -Ls -o /dev/null -w %{url_effective} https://anypoint.mulesoft.com/runtimefabric/api/download/rtfctl/latest | cut -d'?' -f1 | cut -d'-' -f3)"
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"