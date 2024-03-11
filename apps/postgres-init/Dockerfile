FROM ghcr.io/onedr0p/alpine:rolling@sha256:b3d3b9e47e3b5736d045a5e9f2f1d1bbf5c1c38b8c0c296d4609079cfaf9a4bd

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates postgresql16-client~"${VERSION}"

USER kah

COPY ./apps/postgres-init/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/postgres/postgres"
