FROM ghcr.io/onedr0p/alpine:rolling@sha256:236a079145da5ce82269346534cacc8483ddaa8ff1aa4feaaf3a1bf6fb4d1cda

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

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
    pip install --upgrade pip \
    && \
    pip install --upgrade \
      apprise \
      chardet \
      pynzbget \
      rarfile \
    && apk del --purge .build-deps \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

USER kah
COPY ./apps/nzbget/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/nzbget/nzbget"
