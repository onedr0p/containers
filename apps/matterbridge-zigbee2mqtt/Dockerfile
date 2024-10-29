FROM docker.io/library/node:22-alpine AS builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV UMASK="0002"

USER root

#hadolint ignore=DL3018,DL3059
RUN \
    apk add --no-cache \
        bash \
        catatonit \
    && \
    mkdir /.npm && chown -R nobody:nogroup /.npm \
    && npm install -g matterbridge-zigbee2mqtt@${VERSION} --omit=dev \
    && npm cache clean --force

FROM docker.io/library/alpine:3.20 AS runtime

COPY --from=builder --chown=nobody:nobody \
    /usr/local/lib/node_modules/matterbridge-zigbee2mqtt /matterbridge-zigbee2mqtt

# Copy the run script to the container
COPY ./apps/matterbridge-zigbee2mqtt/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

# Start the application using the run.sh script
ENTRYPOINT ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/Luligu/matterbridge-zigbee2mqtt"
