FROM ghcr.io/onedr0p/alpine:rolling@sha256:05007e71bc03db450ca455f02efd74ce69b4a6ca18340fe6d3ef5703e79d2351

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
    org.opencontainers.image.title="qBittorrent ($STREAM)" \
    org.opencontainers.image.source="https://github.com/qbittorrent/qBittorrent" \
    org.opencontainers.image.version="${VERSION}"
