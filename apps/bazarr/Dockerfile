FROM ghcr.io/onedr0p/ubuntu-jammy:rolling@sha256:bee318ee3f33ecee0d752a3cd9a53ea1ea19632f5b930b12d7049dc0b7eca074

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

USER root

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
    export EXTRA_INSTALL_ARG="build-essential libxml2-dev libxslt1-dev python3-dev python3-pip"; \
    apt-get -qq update \
    && \
    apt-get -qq install -y \
        python3 \
        python3-distutils \
        ffmpeg \
        unrar \
        unzip \
        ${EXTRA_INSTALL_ARG} \
    && \
    ln -s /usr/bin/python3 /usr/bin/python \
    && curl -fsSL -o /tmp/app.zip "https://github.com/morpheus65535/bazarr/releases/download/v${VERSION}/bazarr.zip" \
    && unzip -q /tmp/app.zip -d /app \
    && pip3 install --no-cache-dir -U -r /app/requirements.txt \
    && apt-get remove -y ${EXTRA_INSTALL_ARG} \
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

EXPOSE 6767

COPY ./apps/bazarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="Bazarr ($STREAM)" \
    org.opencontainers.image.source="https://github.com/morpheus65535/bazarr" \
    org.opencontainers.image.version="${VERSION}"
