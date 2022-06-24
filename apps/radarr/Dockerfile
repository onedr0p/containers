FROM ghcr.io/onedr0p/alpine:rolling@sha256:05007e71bc03db450ca455f02efd74ce69b4a6ca18340fe6d3ef5703e79d2351

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

ENV \
    RADARR__INSTANCE_NAME="Radarr" \
    RADARR__BRANCH="${STREAM}" \
    RADARR__PORT="7878"

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
    curl -fsSL "https://radarr.servarr.com/v1/update/${RADARR__BRANCH}/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=${ARCH}" \
        | tar xzf - -C /app --strip-components=1 \
    && \
    rm -rf \
        /app/Radarr.Update \
    && \
    printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${RADARR__BRANCH}" "${VERSION}" > /app/package_info \
    && chown -R root:root /app \
    && chmod -R 755 /app

USER kah

COPY ./apps/radarr/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/radarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="${RADARR__INSTANCE_NAME} (${RADARR__BRANCH})" \
    org.opencontainers.image.source="https://github.com/Radarr/Radarr" \
    org.opencontainers.image.version="${VERSION}"
