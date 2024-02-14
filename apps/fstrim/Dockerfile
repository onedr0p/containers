FROM docker.io/library/alpine:3.19.1
ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

RUN apk add --no-cache bash util-linux~"${VERSION}"

COPY ./apps/fstrim/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
