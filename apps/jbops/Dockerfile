FROM ghcr.io/onedr0p/alpine:rolling@sha256:d7f6c7fb07ad7b70a54ee1a1aef8f74b62f9a7959821ae103593224624f09c07

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV PLEXAPI_CONFIG_PATH="/config/config.ini" \
    PLEX_URL="" \
    PLEX_TOKEN="" \
    TAUTULLI_URL="" \
    TAUTULLI_APIKEY="" \
    JBOPS__SCRIPT_PATH="fun/plexapi_haiku.py"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018,DL3013
RUN apk add --no-cache \
        ca-certificates \
        python3 \
    && \
    apk add --no-cache --virtual=build-dependencies \
        build-base \
        libffi-dev \
        openssl-dev \
        musl-dev \
        python3-dev \
        py3-pip \
        git \
    && \
    pip3 install --no-cache-dir --upgrade pip \
    && git clone https://github.com/blacktwin/JBOPS.git . \
    && if [ -n "${VERSION}" ]; then \
        NUMBER_COMMITS_TO_REVERT=$(( $(git rev-list --count --first-parent HEAD) - $(echo "${VERSION}" | cut -d "." -f2) )); \
        git checkout "master~${NUMBER_COMMITS_TO_REVERT}"; \
    fi \
    && \
    pip3 install --no-cache-dir --upgrade --requirement /app/requirements.txt \
    && apk del --purge build-dependencies \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

USER kah
COPY ./apps/jbops/entrypoint.sh /entrypoint.sh

LABEL org.opencontainers.image.source="https://github.com/blacktwin/JBOPS"
