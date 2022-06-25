ARG VERSION
FROM docker.io/library/golang:1.18-alpine3.16 as builder
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT}
#hadolint ignore=DL3018
RUN go install github.com/drone/envsubst/cmd/envsubst@latest

FROM docker.io/library/alpine:${VERSION}
ARG VERSION
ARG STREAM
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}

ENV UMASK="0002" \
    TZ="Etc/UTC"

WORKDIR /app

# hadolint ignore=DL3002
USER root

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
    ca-certificates \
    bash \
    bind-tools \
    curl \
    iputils \
    jo \
    jq \
    nano \
    tini \
    tzdata \
    util-linux \
    wget
#hadolint ignore=DL3018
RUN \
    addgroup -S kah --gid 568 \
        && adduser -S kah -G kah --uid 568 \
        && mkdir -p /config \
        && chown -R kah:kah /config \
        && chmod -R 775 /config \
    && printf "/bin/bash /scripts/greeting.sh\n" > /etc/profile.d/greeting.sh \
    && printf "umask %d" "${UMASK}" > /etc/profile.d/umask.sh \
    && ln -s /usr/bin/nano /usr/local/bin/vi \
    && ln -s /usr/bin/nano /usr/local/bin/vim \
    && ln -s /usr/bin/nano /usr/local/bin/nano \
    && ln -s /usr/bin/nano /usr/local/bin/neovim \
    && ln -s /usr/bin/nano /usr/local/bin/emacs \
    && rm -rf /tmp/*

COPY ./apps/alpine/scripts /scripts
COPY --from=builder /go/bin/envsubst /usr/local/bin/envsubst
ENTRYPOINT ["/sbin/tini", "--"]

LABEL \
    org.opencontainers.image.base.name="ghcr.io/onedr0p/alpine:${VERSION}" \
    org.opencontainers.image.base.version="${VERSION}" \
    org.opencontainers.image.authors="Devin Buhl <devin.kray@gmail.com>, Bernd Schorgers <me@bjw-s.dev>"
