FROM docker.io/library/rust:1.78.0-alpine as cargo
ARG VERSION
WORKDIR /tmp
RUN \
    apk add --no-cache \
        autoconf \
        automake \
        build-base \
        curl \
        linux-headers \
        musl-dev \
    && \
    curl -fsSL "https://github.com/pendulum-project/ntpd-rs/archive/refs/tags/v${VERSION}.tar.gz" \
        | tar xzf - -C /tmp --strip-components 1 \
    && cargo build --release

FROM docker.io/library/alpine:3.19

#hadolint ignore=DL3018,DL3059
RUN apk add --no-cache bash ca-certificates catatonit

COPY --from=cargo /tmp/target/release/ntp-daemon /usr/local/bin/ntp-daemon
COPY --from=cargo /tmp/target/release/ntp-ctl /usr/local/bin/ntp-ctl
COPY --from=cargo /tmp/target/release/ntp-metrics-exporter /usr/local/bin/ntp-metrics-exporter
RUN /usr/local/bin/ntp-daemon --help
RUN /usr/local/bin/ntp-ctl --help
RUN /usr/local/bin/ntp-metrics-exporter --help

COPY ./apps/ntpd-rs/ntp.toml /etc/ntp.toml
COPY ./apps/ntpd-rs/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]
