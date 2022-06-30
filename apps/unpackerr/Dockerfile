ARG VERSION
FROM docker.io/library/golang:1.18-alpine3.16 as builder
ARG VERSION
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ARG TARGETPLATFORM
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT}
# TODO: upx for arm64 not in alpine 3.16
#hadolint ignore=DL3018,DL3059
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') \
            # 1.9M -> 1.0M
            apk add --no-cache git upx \
            && go install -ldflags="-s -w" "github.com/davidnewhall/unpackerr@v${VERSION}" \
            && upx --ultra-brute /go/bin/unpackerr \
        ;; \
        'linux/arm64') \
            apk add --no-cache git \
            && go install -ldflags="-s -w" "github.com/davidnewhall/unpackerr@v${VERSION}" \
        ;; \
    esac

FROM ghcr.io/onedr0p/alpine:rolling@sha256:d7f6c7fb07ad7b70a54ee1a1aef8f74b62f9a7959821ae103593224624f09c07

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=builder /go/bin/unpackerr /app/unpackerr

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates
#hadolint ignore=DL3059
RUN \
    chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

USER kah
COPY ./apps/unpackerr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/davidnewhall/unpackerr"
