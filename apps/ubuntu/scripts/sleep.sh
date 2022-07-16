#!/usr/bin/env bash

min_seconds="${1:-1}"
max_seconds="${2:-3600}"

printf "\e[1;32m%-6s\e[m\n" "INFO: Minimum Seconds set to ${min_seconds}"
printf "\e[1;32m%-6s\e[m\n" "INFO: Maximum Seconds set to ${max_seconds}"

if [[ -z "${seconds}" ]]; then
    seconds="$(shuf -i "${min_seconds}"-"${max_seconds}" -n 1)"
fi

printf "\e[1;32m%-6s\e[m\n" "INFO: Sleeping for ${seconds}s ..."

yes | pv -SL1 -F "Resuming in %e" -s "${seconds}" > /dev/null

printf "\e[1;32m%-6s\e[m\n" "INFO: Done"
