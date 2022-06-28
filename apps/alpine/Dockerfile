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
RUN go install github.com/drone/envsubst/cmd/envsubst@latest
#hadolint ignore=DL3018,DL3059
RUN apk add --no-cache upx
#hadolint ignore=DL3059
RUN \
    # 1.9M -> 1.0M
    upx --ultra-brute /go/bin/envsubst

FROM docker.io/library/alpine:${VERSION}
ARG VERSION
ARG CHANNEL
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
        # 656 kB           # 1.28 MB     # 632 kB
        ca-certificates    bash          bind-tools \
        # 256 kB           # 156 kB      # 40 kB
        curl               iputils       jo \
        # 564 kB           # 200 kB      # 316 kB
        jq                 moreutils     nano \
        # 36 kB            # 3.3 MB      # 320 kB
        tini               tzdata        unzip \
        # 16 kB            # 480 kB
        util-linux         wget \
    && \
    # 264 kB
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.14/main unrar

#hadolint ignore=DL3018
RUN \
    addgroup -S kah --gid 568 \
        && adduser -S kah -G kah --uid 568 \
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
