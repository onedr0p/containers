FROM ghcr.io/onedr0p/alpine:rolling@sha256:6c2e584ea2af3d518dce68b0a57aec5409f71a35639c1445dc1d511210f7325c

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
RUN \
    apk add --no-cache ca-certificates sqlite-libs xmlstarlet \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main tinyxml2 \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community libmediainfo \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing mono
#hadolint ignore=DL3059
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    curl -fsSL "https://download.sonarr.tv/v3/${SONARR__BRANCH}/${VERSION}/Sonarr.${SONARR__BRANCH}.${VERSION}.linux.tar.gz" \
        | tar xzf - -C /app --strip-components=1 \
    && \
    rm -rf \
        /app/Sonarr.Update \
    && \
    printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${SONARR__BRANCH}" "${VERSION}" > /app/package_info \
    && chmod -R 755 /app

USER kah

EXPOSE ${SONARR__PORT}/tcp

COPY ./apps/sonarr/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/sonarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="${SONARR__INSTANCE_NAME} (${SONARR__BRANCH})" \
    org.opencontainers.image.source="https://github.com/Sonarr/Sonarr" \
    org.opencontainers.image.version="${VERSION}"
