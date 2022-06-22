FROM ghcr.io/onedr0p/ubuntu-jammy:rolling@sha256:3eb24c4875328f164308d6c71dac21bd283de0edeb81a2c63859510ebb1d7c41

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

USER root

ENV \
    RADARR__INSTANCE_NAME="Radarr" \
    RADARR__BRANCH="${STREAM}" \
    RADARR__PORT="7878"

# hadolint ignore=DL3008,DL3015
RUN \
    apt-get -qq update \
    && \
    apt-get -qq install -y \
        ca-certificates \
        libicu70 \
        libsqlite3-0 \
        xmlstarlet \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    curl -fsSL -o /tmp/radarr.tar.gz \
        "https://radarr.servarr.com/v1/update/${RADARR__BRANCH}/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=${ARCH}" \
    && tar ixzf /tmp/radarr.tar.gz -C /app --strip-components 1 \
    && \
    rm -rf \
        /app/Radarr.Update* \
    && \
    printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${RADARR__BRANCH}" "${VERSION}" > /app/package_info \
    && \
    apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/ \
    && chown -R kah:kah /app \
    && chmod -R u=rwX,go=rX /app \
    && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah

EXPOSE ${RADARR__PORT}/tcp

COPY ./apps/radarr/_hack/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/radarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="${RADARR__INSTANCE_NAME}" \
    org.opencontainers.image.source="https://github.com/Radarr/Radarr" \
    org.opencontainers.image.version="${VERSION}"
