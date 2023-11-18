ARG VERSION
FROM public.ecr.aws/docker/library/alpine:3.18 as builder
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
    && go install -a -ldflags "-X=main.volsyncVersion=v${VERSION}" github.com/backube/volsync@v${VERSION} \
    && upx /go/bin/volsync

FROM docker.io/restic/restic:0.16.2 as restic

FROM public.ecr.aws/docker/library/alpine:3.18
ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        curl \
        tzdata \
    && \
    curl -fsSL "https://github.com/backube/volsync/archive/refs/tags/v${VERSION}.tar.gz" \
        | tar xzf - -C /tmp --strip-components=1 \
    && mkdir -p /mover-restic \
        && cp /tmp/mover-restic/entry.sh /mover-restic/ \
        && chmod a+rx /mover-restic/*.sh \
    && rm -rf /tmp/*

COPY --from=restic /usr/bin/restic /usr/local/bin/restic
COPY --from=builder /go/bin/volsync /manager

ENTRYPOINT ["/bin/bash"]

LABEL org.opencontainers.image.source="https://github.com/backube/volsync"
