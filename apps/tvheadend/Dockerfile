FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:a0c4a4b02ef13de4c7a83b21ce1ad0f73b43f0c913c1566a39d510360156a4fd as build

ENV \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    DEBIAN_FRONTEND="noninteractive" \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
    UMASK="0002" \
    TZ="Etc/UTC"

RUN \
    apt update && apt -y install \
    build-essential devscripts debhelper git \
    pkg-config libavahi-client-dev libssl-dev zlib1g-dev liburiparser-dev python3-requests cmake libpcre3-dev libdvbcsa-dev \
    && git clone --depth 1 https://github.com/tvheadend/tvheadend.git \
    && cd tvheadend \
    && ./Autobuild.sh

LABEL org.opencontainers.image.source="https://github.com/tvheadend/tvheadend"
