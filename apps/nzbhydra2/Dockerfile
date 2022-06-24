FROM ghcr.io/onedr0p/alpine:rolling@sha256:c85683b371b07fc4cc5ddcd088268242dead371c8eba114b39d6678391559c5b

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates openjdk11-jre-headless python3
#hadolint ignore=DL3018,DL3059
RUN \
  apk add --no-cache --virtual .build-deps unzip \
  && \
  curl -fsSL -o /tmp/nzbhydra2.zip \
    "https://github.com/theotherp/nzbhydra2/releases/download/v${VERSION}/nzbhydra2-${VERSION}-linux.zip" \
  && unzip -q /tmp/nzbhydra2.zip -d /app \
  && apk del --purge .build-deps \
  && chown -R root:root /app \
  && chmod -R 755 /app \
  && rm -rf /tmp/*

USER kah
COPY ./apps/nzbhydra2/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="NZBHydra2 (${STREAM})" \
    org.opencontainers.image.source="https://github.com/theotherp/nzbhydra2" \
    org.opencontainers.image.version="${VERSION}"
