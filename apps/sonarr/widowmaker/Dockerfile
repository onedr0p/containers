FROM ghcr.io/onedr0p/alpine:rolling@sha256:12f1f351282f16ec0e6beda919fcad1b11014c4be3e6be8cef00cb8dc94fa764

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

ENV \
    SONARR__INSTANCE_NAME="Sonarr" \
    SONARR__BRANCH="${STREAM}" \
    SONARR__PORT="8989"

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
    curl -fsSL "https://sonarr.servarr.com/v1/update/${SONARR__BRANCH}/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=${ARCH}" \
        | tar xzf - -C /app --strip-components=1 \
    && \
    rm -rf \
        /app/Sonarr.Update \
    && \
    printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${SONARR__BRANCH}" "${VERSION}" > /app/package_info \
    && chmod -R 755 /app

USER kah

EXPOSE ${SONARR__PORT}/tcp

COPY ./apps/sonarr/${SONARR__BRANCH}/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/sonarr/${SONARR__BRANCH}/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="${SONARR__INSTANCE_NAME} (${SONARR__BRANCH})" \
    org.opencontainers.image.source="https://github.com/Sonarr/Sonarr" \
    org.opencontainers.image.version="${VERSION}"
