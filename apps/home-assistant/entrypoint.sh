#!/usr/bin/env bash
#shellcheck disable=SC2086

unset UV_SYSTEM_PYTHON
# Ensure $VENV_FOLDER directory exists.
mkdir -p "${VENV_FOLDER}"

# Create venv if required.
uv venv --system-site-packages --allow-existing "${VENV_FOLDER}"
# Install uv into the venv if required. This is needed for home-assistant to properly invoke uv to install additional deps.
uv pip freeze --system | grep ^uv= | xargs uv pip install
# Activate the venv
source "${VENV_FOLDER}/bin/activate"

if [[ "${HOME_ASSISTANT__HACS_INSTALL}" == "true" ]]; then
    curl -sfSL https://get.hacs.xyz | bash -
fi

exec \
    python3 -m homeassistant \
        --config /config \
        "$@"
