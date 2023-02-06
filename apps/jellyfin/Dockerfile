FROM ghcr.io/onedr0p/ubuntu:jammy-20221101@sha256:bf2d52a2e698ab9c2e0a1af7f7b70b9806091c5ca21d9f1a4d1c3809f41e5e93

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
    apt-get -qq update \
    && \
    apt-get -qq install -y \
        gnupg2 \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') \
            curl -sL https://repositories.intel.com/graphics/intel-graphics.key | apt-key add - \
            && echo 'deb [arch=amd64] https://repositories.intel.com/graphics/ubuntu jammy main' > /etc/apt/sources.list.d/intel.list \
            && \
            export ARCH='amd64'; \
            export EXTRA_INSTALL_ARG='intel-media-va-driver-non-free nvidia-opencl-icd-340 i965-va-driver mesa-va-drivers'; \
        ;; \
        'linux/arm64') \
            apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6587FFD6536B8826E88A62547876AE518CBCF2F2 \
            && echo "deb http://ppa.launchpad.net/ubuntu-raspi2/ppa-nightly/ubuntu focal main" | tee /etc/apt/sources.list.d/raspberrypi.list \
            && \
            export ARCH='arm64'; \
            export EXTRA_INSTALL_ARG='libomxil-bellagio0 libomxil-bellagio-bin libraspberrypi0'; \
            unset NVIDIA_DRIVER_CAPABILITIES; \
        ;; \
    esac \
    && \
    apt-get -qq update \
    && \
    apt-get -qq install -y \
        ca-certificates \
        ${EXTRA_INSTALL_ARG} \
    && \
    curl -fsSL "https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key" | apt-key add - && \
    echo "deb [arch=${ARCH}] https://repo.jellyfin.org/ubuntu jammy main" | tee /etc/apt/sources.list.d/jellyfin.list && \
    apt-get -qq update && \
    apt-get -qq install -y \
        jellyfin-server="${VERSION}*" \
        jellyfin-web \
        jellyfin-ffmpeg5 \
    && \
    apt-get remove -y gnupg2 \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/ \
    && printf "umask %d\n" "${UMASK}" >> /etc/bash.bashrc

USER kah
COPY ./apps/jellyfin/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/jellyfin/jellyfin"
