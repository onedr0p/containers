FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:a0c4a4b02ef13de4c7a83b21ce1ad0f73b43f0c913c1566a39d510360156a4fd as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

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
            && echo 'deb [arch=amd64] https://repositories.intel.com/graphics/ubuntu focal main' > /etc/apt/sources.list.d/intel.list \
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
    echo "deb [arch=${ARCH}] https://repo.jellyfin.org/ubuntu focal main" | tee /etc/apt/sources.list.d/jellyfin.list && \
    apt-get -qq update && \
    apt-get -qq install -y \
        jellyfin-server="${VERSION}*" \
        jellyfin-web \
        jellyfin-ffmpeg \
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
    && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah
COPY ./apps/jellyfin/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/jellyfin/jellyfin"
