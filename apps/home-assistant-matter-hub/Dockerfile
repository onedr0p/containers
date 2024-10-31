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
    && npm install -g home-assistant-matter-hub@${VERSION} --omit=dev \
    && npm cache clean --force

USER nobody:nogroup

# Copy the run script to the container
COPY ./apps/home-assistant-matter-hub/entrypoint.sh /entrypoint.sh

ENV HAMH_LOG_LEVEL="info"
ENV HAMH_DISABLE_LOG_COLORS="false"

ENV HAMH_STORAGE_LOCATION="/data"
VOLUME /data

ENV HAMH_WEB_PORT=8482
EXPOSE 8482

ENV HAMH_HOME_ASSISTANT_URL="http://x.x.x.x:yyyy"
ENV HAMH_HOME_ASSISTANT_ACCESS_TOKEN="access-token"

# Start the application using the run.sh script
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/t0bst4r/home-assistant-matter-hub"

ENV HAMH_WEB_PORT=8482
EXPOSE 8482

ENV HAMH_HOME_ASSISTANT_URL="http://x.x.x.x:yyyy"
ENV HAMH_HOME_ASSISTANT_ACCESS_TOKEN="access-token"

RUN mkdir /install
COPY package.tgz /install/app.tgz
RUN npm install -g /install/app.tgz
RUN rm -rf /install

CMD home-assistant-matter-hub start