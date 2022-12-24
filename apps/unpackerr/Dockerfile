ARG VERSION
FROM public.ecr.aws/docker/library/alpine:3.17.0 as builder
ARG VERSION
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ARG TARGETPLATFORM
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT} \
    GOPATH=/go
ENV PATH $GOPATH/bin:$PATH
#hadolint ignore=DL3018
RUN \
    apk add --no-cache git go upx \
    && go install -ldflags="-s -w" "github.com/davidnewhall/unpackerr@v${VERSION}" \
    && upx --ultra-brute /go/bin/unpackerr

FROM ghcr.io/onedr0p/alpine:rolling@sha256:23ca8ffcdfbe16492f0d638b71691985b15b3aa7cc373f366a14ec17275bc584

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=builder /go/bin/unpackerr /app/unpackerr

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
