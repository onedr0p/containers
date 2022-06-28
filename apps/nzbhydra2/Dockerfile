FROM ghcr.io/onedr0p/alpine:rolling@sha256:91b1eb3c014f9695f1cfa1e78c9f4a17ffc6dda218115734aa5d46c8917e5d0a

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates openjdk11-jre-headless python3
#hadolint ignore=DL3018,DL3059
RUN \
  curl -fsSL -o /tmp/nzbhydra2.zip \
    "https://github.com/theotherp/nzbhydra2/releases/download/v${VERSION}/nzbhydra2-${VERSION}-linux.zip" \
  && unzip -q /tmp/nzbhydra2.zip -d /app \
  && chown -R root:root /app \
  && chmod -R 755 /app \
  && rm -rf /tmp/*

USER kah
COPY ./apps/nzbhydra2/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/theotherp/nzbhydra2"
