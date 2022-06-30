FROM ghcr.io/onedr0p/alpine:rolling@sha256:8a86a86f11d3666eb534c5c79e2af4a804ebffa5602b280325a1ae03ffa73011

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018
RUN \
    apk add --no-cache ca-certificates \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community mediainfo
#hadolint ignore=DL3059
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    curl -fsSL -o /app/flood \
        "https://github.com/jesec/flood/releases/download/v${VERSION}/flood-linux-${ARCH}" \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

USER kah
COPY ./apps/flood/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/jesec/flood"
