FROM ghcr.io/onedr0p/ubuntu-jammy:rolling@sha256:bee318ee3f33ecee0d752a3cd9a53ea1ea19632f5b930b12d7049dc0b7eca074

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

ENV TAUTULLI_DOCKER="True"

# hadolint ignore=DL3008,DL3013,DL3015,SC2086
RUN \
    export EXTRA_INSTALL_ARG="build-essential libssl-dev libffi-dev python3-dev python3-pip"; \
    apt-get -qq update \
    && \
    apt-get -qq install -y \
        python3 \
        python3-setuptools \
        ${EXTRA_INSTALL_ARG} \
    && \
    ln -s /usr/bin/python3 /usr/bin/python \
    && \
    curl -fsSL "https://github.com/Tautulli/Tautulli/archive/v${VERSION}.tar.gz" | tar xzf - -C /app --strip-components 1 \
    && \
    echo "${VERSION}" > /app/version.txt \
    && \
    echo "master" > /app/branch.txt \
    && \
    pip3 install --no-cache-dir -U \
	    plexapi pycryptodomex \
    && \
    apt-get remove -y ${EXTRA_INSTALL_ARG} \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/ \
    && chmod -R 755 /app \
    && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah

EXPOSE 8181

COPY ./apps/tautulli/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="Tautulli ($STREAM)" \
    org.opencontainers.image.source="https://github.com/Tautulli/Tautulli" \
    org.opencontainers.image.version="${VERSION}"
