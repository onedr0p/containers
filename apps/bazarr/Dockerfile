FROM ghcr.io/onedr0p/alpine:rolling@sha256:91b1eb3c014f9695f1cfa1e78c9f4a17ffc6dda218115734aa5d46c8917e5d0a

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
    curl -fsSL -o /tmp/app.zip "https://github.com/morpheus65535/bazarr/releases/download/v${VERSION}/bazarr.zip" \
    && unzip -q /tmp/app.zip -d /app \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache ca-certificates ffmpeg python3 py3-lxml py3-numpy py3-gevent py3-cryptography py3-setuptools \
    && \
    apk add --no-cache --virtual .build-deps py3-pip gcc python3-dev musl-dev \
    && \
    pip3 install --no-cache-dir --upgrade pip \
    && \
    pip3 install --no-cache-dir --upgrade \
        gevent-websocket \
        webrtcvad-wheels \
    && apk del --purge .build-deps \
    && rm -rf /tmp/*

USER kah
COPY ./apps/bazarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/morpheus65535/bazarr"
