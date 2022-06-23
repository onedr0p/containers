FROM ghcr.io/onedr0p/alpine:rolling@sha256:12f1f351282f16ec0e6beda919fcad1b11014c4be3e6be8cef00cb8dc94fa764

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

ENV BITTORRENT_PORT=6881 \
    WEBUI_PORT=8080

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates geoip p7zip python3 qbittorrent~"${VERSION}" curl
#hadolint ignore=DL3059
RUN chmod -R 755 /usr/bin/qbittorrent \
    ln -s /usr/bin/qbittorrent /app/qbittorrent

USER kah

EXPOSE ${BITTORRENT_PORT}/tcp ${BITTORRENT_PORT}/udp ${WEBUI_PORT}/tcp

COPY ./apps/qbittorrent/config.py /shim/config.py
COPY ./apps/qbittorrent/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="qBittorrent ($STREAM)" \
    org.opencontainers.image.source="https://github.com/qbittorrent/qBittorrent" \
    org.opencontainers.image.version="${VERSION}"
