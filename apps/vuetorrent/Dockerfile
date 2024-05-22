FROM docker.io/library/alpine:3.20 as build

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

USER root

#hadolint ignore=DL3018,DL3059
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        curl \
        unzip \
        python3 \
        tzdata \
    && \
    curl -fsSL "https://github.com/vuetorrent/vuetorrent/releases/download/v${VERSION}/vuetorrent.zip" > "/tmp/vuetorrent.zip" \
    && unzip -q "/tmp/vuetorrent.zip" \
    && chmod -R u=rwX,go=rX /vuetorrent \
    && rm -rf /tmp/*

FROM docker.io/library/alpine:3.20

USER root
WORKDIR /vuetorrent

COPY --from=build /vuetorrent /vuetorrent

LABEL org.opencontainers.image.source="https://github.com/VueTorrent/VueTorrent"
LABEL org.opencontainers.image.description="The sleekest looking WEBUI for qBittorrent made with Vuejs!"
