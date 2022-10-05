FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:5d310ede7e8ed4254dc62d93f1938b2c242f63661aba7d4d74a96b4dc7e0ae78

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    PLEX_DOWNLOAD="https://downloads.plex.tv/plex-media-server-new" \
    PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="/config/Library/Application Support" \
    PLEX_MEDIA_SERVER_HOME="/usr/lib/plexmediaserver" \
    PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS="6" \
    PLEX_MEDIA_SERVER_USER="kah" \
    PLEX_MEDIA_SERVER_INFO_VENDOR="Docker" \
    PLEX_MEDIA_SERVER_INFO_DEVICE="Docker Container (onedr0p)"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
    apt-get -qq update \
    && \
    apt-get -qq install -y \
        gnupg2 \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') \
            curl -sL https://repositories.intel.com/graphics/intel-graphics.key | apt-key add - \
            && echo 'deb [arch=amd64] https://repositories.intel.com/graphics/ubuntu focal main' > /etc/apt/sources.list.d/intel.list \
            && \
            export ARCH='amd64'; \
            export EXTRA_INSTALL_ARG='intel-opencl-icd=21.49.21786+i643~u20.04'; \
        ;; \
        'linux/arm64') \
            export ARCH='arm64'; \
            export EXTRA_INSTALL_ARG=''; \
        ;; \
    esac \
    && \
    apt-get -qq update \
    && \
    apt-get -qq install -y \
        aria2 \
        uuid-runtime \
        xmlstarlet \
        ca-certificates \
        ${EXTRA_INSTALL_ARG} \
    && \
    echo "Using curl or wget to download the plex debian package result in a qemu failure, why? I dunno" \
    && \
    aria2c -d /tmp -o plex.deb \
        "${PLEX_DOWNLOAD}/${VERSION}/debian/plexmediaserver_${VERSION}_${ARCH}.deb" \
    && \
    dpkg -i --force-confold /tmp/plex.deb \
    && \
    apt-get remove -y aria2 gnupg2 \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /etc/default/plexmediaserver \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/ \
    && chown -R root:root /app \
    && chmod -R 755 "${PLEX_MEDIA_SERVER_HOME}" \
    && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

WORKDIR "${PLEX_MEDIA_SERVER_HOME}"
USER kah
COPY ./apps/plex/plex-preferences.sh /scripts/plex-preferences.sh
COPY ./apps/plex/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
