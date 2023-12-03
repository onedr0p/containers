FROM ghcr.io/onedr0p/alpine:rolling@sha256:55b35f580db486e93271ce2bb5b222ceed8591abd6e5fa99142f9337e0ab504d

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates postgresql15-client~"${VERSION}"

USER kah

COPY ./apps/postgres-init/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/postgres/postgres"
