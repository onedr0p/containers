FROM ghcr.io/onedr0p/alpine:rolling@sha256:23ca8ffcdfbe16492f0d638b71691985b15b3aa7cc373f366a14ec17275bc584

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates
#hadolint ignore=DL3059
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x86_64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    curl -fsSL "https://github.com/navidrome/navidrome/releases/download/v${VERSION}/navidrome_${VERSION}_Linux_${ARCH}.tar.gz" \
        | tar xzf - -C /app \
    && rm /app/LICENSE /app/README.md \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

USER kah
COPY ./apps/navidrome/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/navidrome/navidrome"
