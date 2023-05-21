ARG VERSION=latest@sha256:5b429165fa9642beb87e297fe02c7d545409f8d27a0e67e31670a5f6ea0933c1

FROM ghcr.io/actions/actions-runner:${VERSION}

ENV \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    DEBIAN_FRONTEND="noninteractive" \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
    sudo apt-get -qq update \
    && \
    sudo apt-get install -y \
        curl git wget \
    && \
    sudo rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/
