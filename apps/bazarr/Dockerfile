FROM docker.io/library/python:3.11-alpine

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root
WORKDIR /app

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        curl \
        ffmpeg \
        jq \
        mediainfo \
        nano \
        tzdata \
        unzip \
        libpq \
    && \
    apk add --no-cache --virtual .build-deps \
        gcc \
        libffi-dev \
        musl-dev \
        postgresql-dev \
    && \
    pip install --upgrade "cryptography>=42.0.7" \
    pip install --upgrade "gevent>=24.2.1" \
    pip install --upgrade "lxml>=4.3.0, <5.0.0" \
    pip install --upgrade "numpy>=1.12.0" \
    pip install --upgrade --only-binary=Pillow "Pillow>=9.0.0" \
    pip install --upgrade "psycopg2>=2.9.9" \
    pip install --upgrade "setuptools>=70.0.0" \
    pip install --upgrade "webrtcvad-wheels>=2.0.10" \
    && \
    curl -fsSL -o /tmp/app.zip "https://github.com/morpheus65535/bazarr/releases/download/v${VERSION}/bazarr.zip" \
    && unzip -q /tmp/app.zip -d /app \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && apk del --purge .build-deps \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

COPY ./apps/bazarr/entrypoint.sh /entrypoint.sh
COPY --from=ghcr.io/linuxserver/unrar:7.0.7 /usr/bin/unrar-alpine /usr/bin/unrar

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/morpheus65535/bazarr"
