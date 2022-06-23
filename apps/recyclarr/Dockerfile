FROM ghcr.io/onedr0p/alpine:rolling@sha256:12f1f351282f16ec0e6beda919fcad1b11014c4be3e6be8cef00cb8dc94fa764

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

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
    apk add --no-cache --virtual .build-deps unzip \
    && \
    curl -fsSL -o /tmp/app.zip \
        "https://github.com/recyclarr/recyclarr/releases/download/v${VERSION}/recyclarr-linux-${ARCH}.zip" \
    && unzip -q /tmp/app.zip -d /app \
    && chmod -R 755 /app \
    && apk del .build-deps \
    && rm -rf /tmp/*

USER kah

CMD ["/app/recyclarr"]

LABEL \
    org.opencontainers.image.title="Recyclarr" \
    org.opencontainers.image.source="https://github.com/recyclarr/recyclarr" \
    org.opencontainers.image.version="${VERSION}"
