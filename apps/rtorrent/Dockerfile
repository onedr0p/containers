FROM ghcr.io/onedr0p/alpine:rolling@sha256:8a86a86f11d3666eb534c5c79e2af4a804ebffa5602b280325a1ae03ffa73011

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-amd64}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates
#hadolint ignore=DL3059
RUN curl -fsSL -o /app/rtorrent \
        "https://github.com/jesec/rtorrent/releases/download/v${VERSION}/rtorrent-linux-${TARGETARCH}" \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

USER kah
COPY ./apps/rtorrent/rtorrent.rc /app/rtorrent.rc
COPY ./apps/rtorrent/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/jesec/rtorrent"
