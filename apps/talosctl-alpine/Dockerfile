ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL
FROM --platform=${TARGETPLATFORM} ghcr.io/siderolabs/talosctl:${VERSION} as talosctl
FROM ghcr.io/onedr0p/alpine:rolling@sha256:0e3067295cc20dafbd4cf63789ccc71858ad555f3998200ca10b271328c7285e

COPY --from=talosctl /talosctl /usr/local/bin/talosctl

ENTRYPOINT [ "/usr/local/bin/talosctl" ]

LABEL org.opencontainers.image.source="https://github.com/siderolabs/talos"