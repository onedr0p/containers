#!/usr/bin/env bash

APP="${1}"
CHANNEL="${2}"

if test -f "./apps/${APP}/ci/latest.sh"; then
    bash ./apps/"${APP}"/ci/latest.sh "${CHANNEL}"
fi
