#!/usr/bin/env bash

APP="${1}"
CHANNEL="${2}"

bash ./apps/"${APP}"/latest-version.sh "${CHANNEL}"
