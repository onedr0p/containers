FROM ghcr.io/onedr0p/alpine:rolling@sha256:6c2e584ea2af3d518dce68b0a57aec5409f71a35639c1445dc1d511210f7325c

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

ENV \
    PROWLARR__INSTANCE_NAME="Prowlarr" \
    PROWLARR__BRANCH="${STREAM}" \
    PROWLARR__PORT="9696"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates icu-libs libintl sqlite-libs xmlstarlet
#hadolint ignore=DL3059
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    curl -fsSL "https://prowlarr.servarr.com/v1/update/${PROWLARR__BRANCH}/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=${ARCH}" \
        | tar xzf - -C /app --strip-components=1 \
    && \
    rm -rf \
        /app/Prowlarr.Update \
    && \
    printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${PROWLARR__BRANCH}" "${VERSION}" > /app/package_info \
    && chmod -R 755 /app

USER kah

EXPOSE ${PROWLARR__PORT}/tcp

COPY ./apps/prowlarr/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/prowlarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="${PROWLARR__INSTANCE_NAME} (${PROWLARR__BRANCH})" \
    org.opencontainers.image.source="https://github.com/Prowlarr/Prowlarr" \
    org.opencontainers.image.version="${VERSION}"
