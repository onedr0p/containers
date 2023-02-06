FROM alpine:edge AS builder
RUN apk add --no-cache \
    autoconf \
    automake \
    binutils \
    cmake \
    curl \
    dpkg \
    file \
    g++ \
    gcc \
    git \
    libc6-compat \
    libdrm-dev \
    libtool \
    libxshmfence \
    linux-headers \
    make \
    mesa-va-gallium \
    musl-dev \
    nghttp2-dev \
    pkgconfig \
    xxd

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM builder AS amd

WORKDIR /tmp/amd

RUN ls -la /usr/lib/

RUN apk add  xf86-video-amdgpu linux-firmware-amdgpu --no-cache --update-cache \
 && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing libva-utils \
 && mkdir -p "/output/usr/bin" \
 && cp -a /usr/bin/vainfo "/output/usr/bin" \
 && mkdir -p "/output/usr/lib" \
 && cp -a /usr/lib/libX*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libwayland*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libva*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libdrm*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libbsd*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libxshmfence*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libxcb*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libffi*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libLLVM*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libzstd*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libexpat*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libelf*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libstdc++*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libgcc_s*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libmd*.so* "/output/usr/lib" \
 && cp -a /usr/lib/libxml2*.so* "/output/usr/lib" \
 && mkdir -p "/output/usr/lib/dri" \
 && cp -a /usr/lib/dri/*.so* "/output/usr/lib/dri" \
 && mkdir -p "/output/usr/share/libdrm" \
 && cp -a /usr/share/libdrm/* "/output/usr/share/libdrm" \
 && cp -a /lib/ld-musl-x86_64.so.1 "/output/usr/lib" \
 && cp -a /lib/libz*.so* "/output/usr/lib"


FROM ghcr.io/onedr0p/ubuntu:jammy-20221101@sha256:bf2d52a2e698ab9c2e0a1af7f7b70b9806091c5ca21d9f1a4d1c3809f41e5e93

ARG TARGETPLATFORM
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

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') \
            export ARCH='amd64'; \
        ;; \
        'linux/arm64') \
            export ARCH='arm64'; \
        ;; \
    esac \
    && \
    apt-get -qq update \
    && \
    apt-get -qq install -y \
        uuid-runtime \
        xmlstarlet \
        ca-certificates \
        mesa-va-drivers \
        vainfo \
        mesa-vdpau-drivers \
        libdrm-amdgpu1 \
        libavutil56 \
    && \
    curl -fsSL -o /tmp/plex.deb \
        "${PLEX_DOWNLOAD}/${VERSION}/debian/plexmediaserver_${VERSION}_${ARCH}.deb" \
    && \
    dpkg -i --force-confold /tmp/plex.deb \
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
    && printf "umask %d\n" "${UMASK}" >> /etc/bash.bashrc

# Copy lib files
COPY --from=amd /output/usr/lib/dri/*.so* /usr/lib/plexmediaserver/lib/dri/
COPY --from=amd /output/usr/lib/ld-musl-x86_64.so.1 /usr/lib/plexmediaserver/lib/
COPY --from=amd /output/usr/lib/libdrm*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd /output/usr/lib/libelf*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd /output/usr/lib/libffi*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd /output/usr/lib/libgcc_s*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd /output/usr/lib/libLLVM*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd /output/usr/lib/libstdc++*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd /output/usr/lib/libva*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd /output/usr/lib/libxml2*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd /output/usr/lib/libz*.so.* /usr/lib/plexmediaserver/lib/
COPY --from=amd /output/usr/lib/libzstd*.so* /usr/lib/plexmediaserver/lib/



WORKDIR "${PLEX_MEDIA_SERVER_HOME}"
USER kah
COPY ./apps/plex/plex-preferences.sh /scripts/plex-preferences.sh
COPY ./apps/plex/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
