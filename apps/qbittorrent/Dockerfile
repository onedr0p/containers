FROM ghcr.io/onedr0p/alpine:rolling@sha256:236a079145da5ce82269346534cacc8483ddaa8ff1aa4feaaf3a1bf6fb4d1cda

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV QBITTORRENT__PORT=8080 \
    QBITTORRENT__BT_PORT=50413

#hadolint ignore=DL3018
RUN \
    apk add --no-cache ca-certificates geoip p7zip python3 \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community qt6-qtbase-sqlite qbittorrent-nox~"${VERSION}"
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
