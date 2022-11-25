ARG OUTPUT=/output
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

ARG CFLAGS
ARG LDFLAGS
ARG MAKEFLAGS
ARG OUTPUT
ARG DESTDIR

WORKDIR /tmp/amd

RUN ls -la /usr/lib/

RUN apk add  xf86-video-amdgpu linux-firmware-amdgpu --no-cache --update-cache \
 && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing libva-utils \
 && mkdir -p "$OUTPUT/usr/bin" \
 && cp -a /usr/bin/vainfo "$OUTPUT/usr/bin" \
 && mkdir -p "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libX*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libwayland*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libva*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libdrm*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libbsd*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libxshmfence*.so* "$OUTPUT/usr/lib" \
 # && cp -a /usr/lib/libkms*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libxcb*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libffi*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libLLVM*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libzstd*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libexpat*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libelf*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libstdc++*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libgcc_s*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libmd*.so* "$OUTPUT/usr/lib" \
 && cp -a /usr/lib/libxml2*.so* "$OUTPUT/usr/lib" \
 && mkdir -p "$OUTPUT/usr/lib/dri" \
 && cp -a /usr/lib/dri/*.so* "$OUTPUT/usr/lib/dri" \
 && mkdir -p "$OUTPUT/usr/share/libdrm" \
 && cp -a /usr/share/libdrm/* "$OUTPUT/usr/share/libdrm" \
 && cp -a /lib/ld-musl-x86_64.so.1 "$OUTPUT/usr/lib" \
 && cp -a /lib/libz*.so* "$OUTPUT/usr/lib"


FROM ghcr.io/onedr0p/ubuntu:jammy-20221101@sha256:0c17d074e9ef315e08a4f462fc40bb3401d2dd940b516b3deba828a744af8381

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL
ARG OUTPUT=/output

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
    # && ln -sf /usr/lib/x86_64-linux-gnu/dri/*.so* /usr/lib/plexmediaserver/lib/dri \
    # && ln -sf /usr/lib/x86_64-linux-gnu/libdrm*.so* /usr/lib/plexmediaserver/lib \
    # && ln -sf /usr/lib/x86_64-linux-gnu/libelf*.so* /usr/lib/plexmediaserver/lib \
    # && ln -sf /usr/lib/x86_64-linux-gnu/libgcc_s*.so* /usr/lib/plexmediaserver/lib \
    # && ln -sf /usr/lib/x86_64-linux-gnu/libLLVM*.so* /usr/lib/plexmediaserver/lib \
    # && ln -sf /usr/lib/x86_64-linux-gnu/libva*.so* /usr/lib/plexmediaserver/lib \
    # && ln -sf /usr/lib/x86_64-linux-gnu/libxml2*.so* /usr/lib/plexmediaserver/lib \
    # && ln -sf /usr/lib/x86_64-linux-gnu/libz*.so.* /usr/lib/plexmediaserver/lib \
    # && ln -sf /usr/lib/x86_64-linux-gnu/libzstd*.so* /usr/lib/plexmediaserver/lib \
    && chmod -R 755 "${PLEX_MEDIA_SERVER_HOME}" \
    && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

# Copy lib files
COPY --from=amd $OUTPUT/usr/lib/dri/*.so* /usr/lib/plexmediaserver/lib/dri/
COPY --from=amd $OUTPUT/usr/lib/ld-musl-x86_64.so.1 /usr/lib/plexmediaserver/lib/
COPY --from=amd $OUTPUT/usr/lib/libdrm*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd $OUTPUT/usr/lib/libelf*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd $OUTPUT/usr/lib/libffi*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd $OUTPUT/usr/lib/libgcc_s*.so* /usr/lib/plexmediaserver/lib/
# COPY --from=amd $OUTPUT/usr/lib/libkms*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd $OUTPUT/usr/lib/libLLVM*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd $OUTPUT/usr/lib/libstdc++*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd $OUTPUT/usr/lib/libva*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd $OUTPUT/usr/lib/libxml2*.so* /usr/lib/plexmediaserver/lib/
COPY --from=amd $OUTPUT/usr/lib/libz*.so.* /usr/lib/plexmediaserver/lib/
COPY --from=amd $OUTPUT/usr/lib/libzstd*.so* /usr/lib/plexmediaserver/lib/



WORKDIR "${PLEX_MEDIA_SERVER_HOME}"
USER kah
COPY ./apps/plex/plex-preferences.sh /scripts/plex-preferences.sh
COPY ./apps/plex/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
