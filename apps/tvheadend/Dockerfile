FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:a0c4a4b02ef13de4c7a83b21ce1ad0f73b43f0c913c1566a39d510360156a4fd as builder

ENV \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    DEBIAN_FRONTEND="noninteractive" \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
    UMASK="0002" \
    TZ="Etc/UTC"

RUN \
    apt update && apt -y install \
    build-essential devscripts debhelper git python \
    pkg-config libavahi-client-dev libssl-dev zlib1g-dev liburiparser-dev python3-requests cmake libpcre3-dev libdvbcsa-dev \
    && git clone --depth 1 https://github.com/tvheadend/tvheadend.git \
    && cd tvheadend \
    && JOBSARGS=$(nproc) ./Autobuild.sh \
    && cd .. \
    && ar x tvheadend_0.0.0-unknown_amd64.deb \
    && tar -xvf data.tar.gz \
    && rm -rf control.tar.gz data.tar.gz debian-binary tvheadend \
    tvheadend_0.0.0-unknown_amd64.buildinfo tvheadend_0.0.0-unknown_amd64.changes \
    tvheadend_0.0.0-unknown_amd64.deb tvheadend-dbg_0.0.0-unknown_amd64.deb

FROM ghcr.io/onedr0p/alpine:rolling@sha256:d7f6c7fb07ad7b70a54ee1a1aef8f74b62f9a7959821ae103593224624f09c07

COPY --from=builder /app/usr/* /app
COPY --from=builder /app/lib/* /app

ENTRYPOINT ["/app/bin/tvheadend"]

LABEL org.opencontainers.image.source="https://github.com/tvheadend/tvheadend"
