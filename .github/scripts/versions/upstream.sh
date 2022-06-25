#!/usr/bin/env bash

APP="${1}"
CHANNEL="${2}"

bash ./apps/"${APP}"/ci/latest.sh "${CHANNEL}"
