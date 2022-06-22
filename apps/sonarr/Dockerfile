FROM ghcr.io/onedr0p/ubuntu-jammy:rolling@sha256:3eb24c4875328f164308d6c71dac21bd283de0edeb81a2c63859510ebb1d7c41

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

USER root

ENV \
    SONARR__INSTANCE_NAME="Sonarr" \
    SONARR__BRANCH="${STREAM}" \
    SONARR__PORT="8989"

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
    apt-get -qq update \
    && apt-get -qq install -y gnupg \
	&& \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official.list \
    && apt-get -qq update \
    && \
    apt-get -qq install -y \
        ca-certificates \
        mono-complete \
        ca-certificates-mono \
        libmediainfo0v5 \
        xmlstarlet \
    && \
    curl -fsSL -o /tmp/sonarr.tar.gz \
        "https://download.sonarr.tv/v3/${SONARR__BRANCH}/${VERSION}/Sonarr.${SONARR__BRANCH}.${VERSION}.linux.tar.gz" \
    && tar ixzf /tmp/sonarr.tar.gz -C /app --strip-components 1 \
    && \
    rm -rf \
        /app/Sonarr.Update* \
    && \
    printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team k8s-at-home](https://github.com/k8s-at-home)" "${SONARR__BRANCH}" "${VERSION}" > /app/package_info \
    && \
    gpgconf --kill all \
    && apt-get remove -y gnupg \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /var/tmp/ \
    && chown -R kah:kah /app \
    && chmod -R u=rwX,go=rX /app \
    && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah

EXPOSE ${SONARR__PORT}/tcp

COPY ./apps/sonarr/_hack/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/sonarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="${SONARR__INSTANCE_NAME} (${SONARR__BRANCH})" \
    org.opencontainers.image.source="https://github.com/Sonarr/Sonarr" \
    org.opencontainers.image.version="${VERSION}"
