FROM docker.io/library/alpine:3.19

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

USER root
WORKDIR /tmp

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        postgresql16-client~"${VERSION}"

WORKDIR /app
COPY ./apps/postgres-init/entrypoint.sh /entrypoint.sh
COPY --from=envsubst /go/bin/envsubst /usr/local/bin/envsubst

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/postgres/postgres"
