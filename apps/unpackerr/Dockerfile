FROM ghcr.io/onedr0p/alpine:rolling@sha256:4b666f73ee079b4feac9527fae3b0e60b0e9883213758bdb28af852c9acb4efe

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates
#hadolint ignore=DL3059
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='amd64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    curl -fsSL "https://github.com/Unpackerr/unpackerr/releases/download/v${VERSION}/unpackerr.${ARCH}.linux.gz" \
        -o /tmp/unpackerr.gz \
    && gzip -dc < /tmp/unpackerr.gz > /app/unpackerr \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

USER kah
COPY ./apps/unpackerr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/Unpackerr/unpackerr"
