FROM ghcr.io/onedr0p/alpine:rolling@sha256:ed7edf90c1e7df516ff37267841a17d0bedf7ef873f8f81bb3ddf06b3a464d06

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates postgresql14-client~"${VERSION}"

USER kah

COPY ./apps/postgres-initdb/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/postgres/postgres"
