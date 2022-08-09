ARG VERSION
FROM public.ecr.aws/docker/library/rust:1.62.1-alpine3.16 as builder
ARG VERSION
ARG TARGETPLATFORM
WORKDIR /usr/src/microbin
# TODO: upx for arm64 not in alpine 3.16
#hadolint ignore=DL3018,DL3059
RUN \
    apk add --no-cache git musl-dev \
    && \
    git clone --branch "v${VERSION}" --depth 1 https://github.com/szabodanika/microbin.git . \
    && \
    find ./ -type f -exec sed -i 's|\./pasta_data/public|/config/public|gi' {} \; \
    && \
    find ./ -type f -exec sed -i 's|pasta_data/database.json|/config/database.json|gi' {} \; \
    && \
    cargo build --release

FROM ghcr.io/onedr0p/alpine:rolling@sha256:8526855bd62a0c567f085439f5691701bbc3707d40147fe3afe117e2e6c4a305

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=builder /usr/src/microbin/target/release/microbin /app/microbin

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates
#hadolint ignore=DL3059
RUN \
    chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

USER kah
COPY ./apps/microbin/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/szabodanika/microbin"
