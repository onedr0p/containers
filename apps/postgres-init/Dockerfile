FROM ghcr.io/onedr0p/alpine:rolling@sha256:974f5883eb9b838792f1b27b812d8b9f80375ba9ac1f8b038fda27a53f6cd763

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates postgresql14-client~"${VERSION}"

USER kah

COPY ./apps/postgres-init/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/postgres/postgres"
