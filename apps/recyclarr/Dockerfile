FROM ghcr.io/onedr0p/alpine:rolling@sha256:e25d6744afe5ae0c03e0b2af4977c2d7df3f56b713c3b5cdffb8c372edf626be

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    RECYCLARR_APP_DATA=/config \
    DOTNET_BUNDLE_EXTRACT_BASE_DIR=/tmp/.net \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates
#hadolint ignore=DL3018,DL3059
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    curl -fsSL -o /tmp/app.zip \
        "https://github.com/recyclarr/recyclarr/releases/download/v${VERSION}/recyclarr-linux-musl-${ARCH}.zip" \
    && unzip -q /tmp/app.zip -d /app \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

USER kah

CMD ["/app/recyclarr"]

LABEL org.opencontainers.image.source="https://github.com/recyclarr/recyclarr"
