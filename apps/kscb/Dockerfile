FROM ghcr.io/onedr0p/alpine:rolling@sha256:d7f6c7fb07ad7b70a54ee1a1aef8f74b62f9a7959821ae103593224624f09c07

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
  KSCB__SCHEDULE="@daily" \
  KSCB__HEALTHCHECK_PORT=18080 \
  KSCB__SOURCE="**None**" \
  KSCB__DESTINATION="**None**"\
  KSCB__KEEP_DAYS=7 \
  KSCB__KEEP_WEEKS=4 \
  KSCB__KEEP_MONTHS=6 \
  KSCB__KEEP_MINS=1440

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='amd64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && curl -L https://github.com/prodrigestivill/go-cron/releases/download/${VERSION}/go-cron-linux-${ARCH}-static.gz | zcat > /usr/local/bin/go-cron \
    && chmod +x /usr/local/bin/go-cron \
    && rm -rf \
        /tmp/*

USER kah

COPY ./apps/kscb/backup.sh /app/backup.sh
COPY ./apps/kscb/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f "http://localhost:$KSCB__HEALTHCHECK_PORT/" || exit 1
