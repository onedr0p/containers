FROM ghcr.io/onedr0p/ubuntu-focal:rolling@sha256:3761cc85d317e073e8e0c04aee8a9aceb41c3f9c25cdc29e21f788fa1c1c5beb

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

USER root

ENV \
    RECYCLARR_APP_DATA=/config \
    DOTNET_BUNDLE_EXTRACT_BASE_DIR=/tmp/.net \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

RUN \
    apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends \
        ca-certificates \
        libssl1.1 \
        unzip \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    curl -fsSL -o /tmp/app.zip \
        "https://github.com/recyclarr/recyclarr/releases/download/v${VERSION}/recyclarr-linux-${ARCH}.zip" \
    && unzip -q /tmp/app.zip -d /app \
    && apt-get remove -y unzip \
    && apt-get purge -y --autoremove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get clean \
    && rm -rf \
        /tmp/* \
        /var/lib/apt/lists/ \
        /var/tmp/* \
    && chown -R kah:kah /app \
    && chmod -R 755 /app \
    && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah

CMD ["/app/recyclarr"]

LABEL \
    org.opencontainers.image.title="Recyclarr" \
    org.opencontainers.image.source="https://github.com/recyclarr/recyclarr" \
    org.opencontainers.image.version="${VERSION}"
