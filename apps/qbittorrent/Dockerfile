FROM ghcr.io/onedr0p/alpine:rolling@sha256:8a86a86f11d3666eb534c5c79e2af4a804ebffa5602b280325a1ae03ffa73011

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV BITTORRENT_PORT=6881 \
    WEBUI_PORT=8080

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
