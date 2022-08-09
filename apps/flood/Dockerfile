FROM ghcr.io/onedr0p/alpine:rolling@sha256:8526855bd62a0c567f085439f5691701bbc3707d40147fe3afe117e2e6c4a305

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV FLOOD_OPTION_rundir="/config" \
    FLOOD_OPTION_host="0.0.0.0" \
    FLOOD_OPTION_port="3000"
    # For use with rtorrent
    # FLOOD_OPTION_allowedpath="/config,/sock,/rc"
    # FLOOD_OPTION_rtsocket="/sock/rtorrent.sock"
    # FLOOD_OPTION_rtconfig="/rc/rtorrent.rc"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018
RUN \
    apk add --no-cache ca-certificates \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community mediainfo
#hadolint ignore=DL3059
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    curl -fsSL -o /app/flood \
        "https://github.com/jesec/flood/releases/download/v${VERSION}/flood-linux-${ARCH}" \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

USER kah
COPY ./apps/flood/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/jesec/flood"
