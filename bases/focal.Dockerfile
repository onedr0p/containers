ARG GOLANG_VERSION="1.18-alpine3.16"
ARG UBUNTU_VERSION="focal-20220531"

FROM docker.io/library/golang:${GOLANG_VERSION} as builder
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

FROM docker.io/library/ubuntu:${UBUNTU_VERSION}

ARG UBUNTU_VERSION
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}

# DEBIAN_FRONTEND: https://askubuntu.com/questions/972516/debian-frontend-environment-variable
# APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE: http://stackoverflow.com/questions/48162574/ddg#49462622
ENV \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    DEBIAN_FRONTEND="noninteractive" \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
    UMASK="0002" \
    TZ="Etc/UTC"

# hadolint ignore=DL3002
USER root

RUN \
    adduser kah \
        --uid 568 \
        --group \
        --system \
        --disabled-password \
        --no-create-home \
    && mkdir -p /config \
    && chown -R kah:kah /config \
    && chmod -R 775 /config

WORKDIR /app

# hadolint ignore=DL3008,DL3015
RUN \
    set -eux \
    && echo 'APT::Install-Recommends "false";' >/etc/apt/apt.conf.d/00recommends \
    && echo 'APT::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends \
    && echo 'APT::Get::Install-Recommends "false";' >>/etc/apt/apt.conf.d/00recommends \
    && echo 'APT::Get::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends \
    && \
    apt-get -qq update \
    && \
    apt-get install -y \
        bash \
        ca-certificates \
        curl \
        dnsutils \
        jq \
        locales \
        tini \
        tzdata \
        vim-tiny \
    && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && ln -s /usr/bin/vim.tiny /usr/local/bin/vi \
    && ln -s /usr/bin/vim.tiny /usr/local/bin/vim \
    && ln -s /usr/bin/vim.tiny /usr/local/bin/nano \
    && ln -s /usr/bin/vim.tiny /usr/local/bin/emacs \
    && chown -R kah:kah /app \
    && \
    printf "/bin/bash /scripts/greeting.sh\n" >> /etc/bash.bashrc \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /var/tmp/*

ENV LANG en_US.UTF-8

COPY ./bases/scripts /scripts
COPY --from=builder /go/bin/envsubst /usr/local/bin/envsubst

ENTRYPOINT [ "/usr/bin/tini", "--" ]

LABEL \
    org.opencontainers.image.base.name="ghcr.io/onedr0p/ubuntu-focal" \
    org.opencontainers.image.base.version="${UBUNTU_VERSION}" \
    org.opencontainers.image.authors="Devin Buhl <devin.kray@gmail.com>, Bernd Schorgers <me@bjw-s.dev>"
