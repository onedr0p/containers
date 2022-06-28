FROM ghcr.io/onedr0p/alpine:rolling@sha256:f20b7d333ca66525384105e50939332bc13c53158cd4287779e3501665ed5fb6

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
    curl -fsSL -o /tmp/nzbget.run \
      "https://github.com/nzbget/nzbget/releases/download/v${VERSION}/nzbget-${VERSION}-bin-linux.run" \
    && \
    sh /tmp/nzbget.run --destdir /app \
    && \
    curl -fsSL "https://curl.se/ca/cacert.pem" | sed '/^DST Root CA X3$/,/^-----END CERTIFICATE-----$/d;' > "/app/cacert.pem" \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

#hadolint ignore=DL3013,DL3018
RUN \
    apk add --no-cache ca-certificates p7zip python3 py3-lxml \
    && \
    apk add --no-cache --virtual .build-deps py3-pip \
    && \
    pip3 install --no-cache-dir --upgrade pip \
    && \
    pip3 install --no-cache-dir --upgrade \
      apprise \
      chardet \
      pynzbget \
      rarfile \
    && apk del --purge .build-deps \
    && rm -rf /tmp/*

USER kah
COPY ./apps/nzbget/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/nzbget/nzbget"
