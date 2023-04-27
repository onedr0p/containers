FROM ghcr.io/onedr0p/alpine:rolling@sha256:999384960b6114496a5e4036e945141c205d064ce23b87326bd3f8d878c5a9d4

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates pigz rclone~"${VERSION}" tar zstd
#hadolint ignore=DL3059
RUN chown -R root:root /usr/bin/rclone \
    && chmod -R 755 /usr/bin/rclone \
    && ln -s /usr/bin/rclone /app/rclone \
    && rm -rf /tmp/*

CMD ["/app/rclone"]

LABEL org.opencontainers.image.source="https://github.com/rclone/rclone"
