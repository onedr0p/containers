FROM ghcr.io/onedr0p/alpine:rolling@sha256:b0b6f6f42bf9649ccaf0e98cd74d5e123471e2c4a4db4a5ee417b18dde9973a9

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-amd64}

ENV RTORRENT__DEFAULT_CONFIG="true" \
    RTORRENT__CONFIG_FILE="/config/rtorrent.rc" \
    RTORRENT__SOCKET="/sock/rtorrent.sock" \
    RTORRENT__BT_PORT="50415"

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates
#hadolint ignore=DL3059
RUN curl -fsSL -o /app/rtorrent \
        "https://github.com/jesec/rtorrent/releases/download/v${VERSION}/rtorrent-linux-${TARGETARCH}" \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && mkdir -p "$(dirname "${RTORRENT__SOCKET}")" \
    && chown -R kah:kah "$(dirname "${RTORRENT__SOCKET}")" \
    && chmod -R 775 "$(dirname "${RTORRENT__SOCKET}")" \
    && rm -rf /tmp/*

USER kah
COPY ./apps/rtorrent/rtorrent.rc /app/rtorrent.rc
COPY ./apps/rtorrent/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/jesec/rtorrent"
