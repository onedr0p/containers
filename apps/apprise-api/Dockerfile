FROM ghcr.io/onedr0p/alpine:rolling@sha256:d7f6c7fb07ad7b70a54ee1a1aef8f74b62f9a7959821ae103593224624f09c07

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    APPRISE_CONFIG_DIR=/config

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
    curl -fsSL "https://github.com/caronc/apprise-api/archive/refs/tags/v${VERSION}.tar.gz" \
        | tar xzf - -C /app --strip-components=1 \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

#hadolint ignore=DL3018,DL3013
RUN apk add --no-cache \
        ca-certificates \
        py3-pip \
        python3 \
        uwsgi \
        uwsgi-python \
    && \
    apk add --no-cache --virtual=build-dependencies \
        cargo \
        g++ \
        gcc \
        libffi-dev \
        openssl-dev \
        python3-dev \
    && \
    pip3 install --no-cache-dir --upgrade pip wheel \
    && \
    pip3 install --no-cache-dir --requirement /app/requirements.txt \
    && apk del --purge build-dependencies \
    && rm -rf /tmp/*

USER kah
COPY ./apps/apprise-api/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/caronc/apprise-api"
