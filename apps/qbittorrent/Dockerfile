FROM ghcr.io/onedr0p/alpine:rolling@sha256:6c2e584ea2af3d518dce68b0a57aec5409f71a35639c1445dc1d511210f7325c

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
