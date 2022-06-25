FROM ghcr.io/onedr0p/alpine:rolling@sha256:c85683b371b07fc4cc5ddcd088268242dead371c8eba114b39d6678391559c5b

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

ENV BITTORRENT_PORT=6881 \
    WEBUI_PORT=8080

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018
RUN \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.14/main unrar \
    && \
    apk add --no-cache ca-certificates geoip p7zip python3 qbittorrent-nox~"${VERSION}" unrar
#hadolint ignore=DL3059
RUN chown -R root:root /usr/bin/qbittorrent-nox \
    && chmod -R 755 /usr/bin/qbittorrent-nox \
    && ln -s /usr/bin/qbittorrent-nox /app/qbittorrent-nox \
    && rm -rf /tmp/*

USER kah

COPY ./apps/qbittorrent/config.py /scripts/config.py
COPY ./apps/qbittorrent/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="qBittorrent (${STREAM})" \
    org.opencontainers.image.source="https://github.com/qbittorrent/qBittorrent" \
    org.opencontainers.image.version="${VERSION}"
