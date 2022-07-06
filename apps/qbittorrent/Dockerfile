FROM ghcr.io/onedr0p/alpine:rolling@sha256:4a5fb3d4a3b35eb48156fe08d51c766f526063495cd9b95cd6e31cbd495ad454

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV QBITTORRENT__PORT=8080 \
    QBITTORRENT__BT_PORT=50413

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates geoip p7zip python3 qbittorrent-nox~"${VERSION}"
#hadolint ignore=DL3059
RUN chown -R root:root /usr/bin/qbittorrent-nox \
    && chmod -R 755 /usr/bin/qbittorrent-nox \
    && ln -s /usr/bin/qbittorrent-nox /app/qbittorrent-nox \
    && rm -rf /tmp/*

USER kah

COPY ./apps/qbittorrent/config.py /scripts/config.py
COPY ./apps/qbittorrent/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/qbittorrent/qBittorrent"
