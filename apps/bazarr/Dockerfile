FROM ghcr.io/onedr0p/alpine:rolling@sha256:05007e71bc03db450ca455f02efd74ce69b4a6ca18340fe6d3ef5703e79d2351

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
    curl -fsSL -o /tmp/app.zip "https://github.com/morpheus65535/bazarr/releases/download/v${VERSION}/bazarr.zip" \
    && unzip -q /tmp/app.zip -d /app \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.14/main unrar \
    && \
    apk add --no-cache ffmpeg python3 py3-lxml py3-numpy py3-gevent py3-cryptography py3-setuptools unrar unzip \
    && \
    apk add --no-cache --virtual .build-deps py3-pip gcc python3-dev musl-dev \
    && \
    pip3 install --no-cache-dir --upgrade \
        gevent-websocket \
        webrtcvad-wheels \
    && apk del --purge .build-deps \
    && rm -rf /tmp/*

USER kah
COPY ./apps/bazarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="Bazarr ($STREAM)" \
    org.opencontainers.image.source="https://github.com/morpheus65535/bazarr" \
    org.opencontainers.image.version="${VERSION}"
