FROM ghcr.io/k8s-at-home/ubuntu-focal:rolling@sha256:7f1b8af0e171af574601647215678391d11bff9236525a190e55f5a53e1d5505

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

USER root

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
    PLEX_DOWNLOAD="https://downloads.plex.tv/plex-media-server-new" \
    PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="/config/Library/Application Support" \
    PLEX_MEDIA_SERVER_HOME="/usr/lib/plexmediaserver" \
    PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS="6" \
    PLEX_MEDIA_SERVER_USER="kah" \
    PLEX_MEDIA_SERVER_INFO_VENDOR="Docker" \
    PLEX_MEDIA_SERVER_INFO_DEVICE="Docker Container (k8s-at-home)"

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
        unset NVIDIA_DRIVER_CAPABILITIES; \
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
  && chown -R kah:kah "${PLEX_MEDIA_SERVER_HOME}" \
  && chmod -R u=rwX,go=rX "${PLEX_MEDIA_SERVER_HOME}" \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah

WORKDIR "${PLEX_MEDIA_SERVER_HOME}"

EXPOSE 32400/tcp 1900/udp 3005/tcp 5353/udp 8324/tcp 32410/udp 32412/udp 32413/udp 32414/udp 32469/tcp

COPY ./apps/plex/_hack/plex-preferences.sh /hack/plex-preferences.sh

COPY ./apps/plex/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="Plex - ${STREAM}" \
    org.opencontainers.image.version="${VERSION}"
