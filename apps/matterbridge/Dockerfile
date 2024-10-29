FROM docker.io/library/node:22-alpine

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
        ca-certificates \
        catatonit \
    && \
    mkdir /.npm && chown -R nobody:nogroup /.npm \
    && npm install -g matterbridge@${VERSION} --omit=dev \
    && npm cache clean --force

# Copy the run script to the container
COPY ./apps/matterbridge/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

# Start the application using the run.sh script
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/Luligu/matterbridge"
