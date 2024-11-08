FROM docker.io/library/node:22.11.0-alpine3.20

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root

#hadolint ignore=DL3018,DL3059
RUN \
    apk add --no-cache \
        bash \
        catatonit \
        tzdata \
    && \
    && npm install -g zigbee2mqtt@${VERSION} --omit=dev \
    && npm cache clean --force

USER nobody:nogroup

# Copy the run script to the container
COPY ./apps/zigbee2mqtt/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

# Start the application using the run.sh script
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/Koenkk/zigbee2mqtt"
