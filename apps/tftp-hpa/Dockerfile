FROM docker.io/library/alpine:3.19

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

USER root
WORKDIR /app

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        tftp-hpa~"${VERSION}" \
    && mkdir /config \
    && addgroup -S -g 101 tftpd \
    && adduser -s /bin/false -S -D -H -h /config -G tftpd -u 100 tftpd

COPY ./apps/tftp-hpa/entrypoint.sh /entrypoint.sh

USER tftpd
ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]
