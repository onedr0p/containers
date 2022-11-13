FROM ghcr.io/onedr0p/alpine:rolling@sha256:c3323a3704b6770d02d838e8ab6a1692f9a676a21e5f0dc6d34df32e4fce6d57

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates
#hadolint ignore=DL3059
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='stash-linux' ;; \
        'linux/arm64') export ARCH='stash-linux-arm64v8' ;; \
    esac \
    && \
    curl -fsSL -o /app/stash \
        "https://github.com/stashapp/stash/releases/download/v${VERSION}/${ARCH}" \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

USER kah
COPY ./apps/stash/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/stashapp/stash"
