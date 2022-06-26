FROM ghcr.io/onedr0p/ubuntu-focal:rolling@sha256:72de8714ed3958baa0843658d58e574dda22cbf297d97d7e36da74483aa856c7 as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /tmp

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') \
            export ARCH='x86_64'; \
        ;; \
        'linux/arm64') \
            export ARCH='aarch64'; \
        ;; \
    esac \
    && \
    apt-get update -qq \
    && \
    apt-get install -qqy cpio rpm2cpio \
    && \
    mkdir -p /app/emby \
    && \
    curl -fsSL -o emby.rpm \
        "https://github.com/MediaBrowser/Emby.Releases/releases/download/${VERSION}/emby-server-rpm_${VERSION}_${ARCH}.rpm" \
    && \
    rpm2cpio emby.rpm | cpio -i --make-directories \
    && \
    mv -t \
        /app/emby \
        /tmp/opt/emby-server/system/* \
        /tmp/opt/emby-server/lib/* \
        /tmp/opt/emby-server/bin/ff* \
        /tmp/opt/emby-server/etc \
        /tmp/opt/emby-server/extra/lib/*

FROM ghcr.io/k8s-at-home/ubuntu-focal:rolling@sha256:7f1b8af0e171af574601647215678391d11bff9236525a190e55f5a53e1d5505

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') \
            export EXTRA_INSTALL_ARG='mesa-va-drivers'; \
        ;; \
        'linux/arm64') \
            curl -s "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x6587ffd6536b8826e88a62547876ae518cbcf2f2" | apt-key add - \
            && echo "deb http://ppa.launchpad.net/ubuntu-raspi2/ppa-nightly/ubuntu focal main">> /etc/apt/sources.list.d/raspbins.list \
            && \
            export EXTRA_INSTALL_ARG='libomxil-bellagio0 libomxil-bellagio-bin libraspberrypi0'; \
            unset NVIDIA_DRIVER_CAPABILITIES; \
        ;; \
    esac \
    && \
    apt-get update -qq && \
    apt-get install -qqy ${EXTRA_INSTALL_ARG} \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/ \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah
COPY --from=builder /app/emby /app/emby
COPY ./apps/emby/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
