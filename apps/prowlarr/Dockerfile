FROM ghcr.io/onedr0p/ubuntu-jammy:rolling@sha256:3eb24c4875328f164308d6c71dac21bd283de0edeb81a2c63859510ebb1d7c41

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

USER root

ENV \
    PROWLARR__INSTANCE_NAME="Prowlarr" \
    PROWLARR__BRANCH="${STREAM}" \
    PROWLARR__PORT="9696"

RUN \
    apt-get -qq update \
    && \
    apt-get -qq install -y \
        ca-certificates \
        libchromaprint-tools \
        libicu70 \
        libsqlite3-0 \
        xmlstarlet \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    curl -fsSL -o /tmp/prowlarr.tar.gz \
        "https://prowlarr.servarr.com/v1/update/${PROWLARR__BRANCH}/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=${ARCH}" \
    && tar ixzf /tmp/prowlarr.tar.gz -C /app --strip-components 1 \
    && \
    rm -rf \
        /app/prowlarr.Update* \
    && \
    printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${PROWLARR__BRANCH}" "${VERSION}" > /app/package_info \
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

EXPOSE ${PROWLARR__PORT}/tcp

COPY ./apps/prowlarr/_hack/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/prowlarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="${PROWLARR__INSTANCE_NAME} (${PROWLARR__BRANCH})" \
    org.opencontainers.image.source="https://github.com/Prowlarr/Prowlarr" \
    org.opencontainers.image.version="${VERSION}"
