FROM ghcr.io/onedr0p/ubuntu-jammy:rolling@sha256:3eb24c4875328f164308d6c71dac21bd283de0edeb81a2c63859510ebb1d7c41

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

ENV BITTORRENT_PORT=6881 \
    WEBUI_PORT=8080

USER root

# hadolint ignore=DL3008,DL3013,DL3015,SC2086
RUN \
    export EXTRA_INSTALL_ARG="binutils"; \
    apt-get -qq update \
    && \
    apt-get install -y \
        geoip-bin \
        p7zip-full \
        python3 \
        unrar \
        unzip \
        ${EXTRA_INSTALL_ARG} \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH="x86_64" ;; \
        'linux/arm64') export ARCH="aarch64" ;; \
    esac \
    && curl -fsSL -o /app/qbittorrent-nox "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/${ARCH}-cmake-qbittorrent-nox" \
    && chmod +x /app/qbittorrent-nox \
    && \
    apt-get remove -y ${EXTRA_INSTALL_ARG} \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/ \
    && chown -R kah:kah /app \
    && chmod -R u=rwX,go=rX /app \
    && chown -R kah:kah /config \
    && chmod -R u=rwX,go=rX /config \
    && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah

EXPOSE ${BITTORRENT_PORT} ${BITTORRENT_PORT}/udp ${WEBUI_PORT}

COPY ./apps/qbittorrent/config.py /shim/config.py
COPY ./apps/qbittorrent/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="qBittorrent" \
    org.opencontainers.image.source="https://github.com/qbittorrent/qBittorrent" \
    org.opencontainers.image.version="${VERSION}"
