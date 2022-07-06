FROM ghcr.io/onedr0p/alpine:rolling@sha256:4a5fb3d4a3b35eb48156fe08d51c766f526063495cd9b95cd6e31cbd495ad454

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PIP_NO_CACHE_DIR=1

ENV APPRISE_CONFIG_DIR=/config

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
    apk add --no-cache --virtual=.build-deps \
        cargo \
        g++ \
        gcc \
        libffi-dev \
        openssl-dev \
        python3-dev \
    && \
    pip install --upgrade pip wheel \
    && \
    pip install --requirement /app/requirements.txt \
    && apk del --purge .build-deps \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

USER kah
COPY ./apps/apprise-api/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/caronc/apprise-api"
