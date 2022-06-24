FROM ghcr.io/onedr0p/ubuntu-jammy:rolling@sha256:bee318ee3f33ecee0d752a3cd9a53ea1ea19632f5b930b12d7049dc0b7eca074

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

USER root

# hadolint ignore=DL3008,DL3013,DL3015,SC2086
RUN \
    export EXTRA_INSTALL_ARG="build-essential libffi-dev libssl-dev python3-dev python3-pip"; \
    apt-get -qq update \
    && \
    apt-get -qq install -y \
        p7zip-full \
        par2 \
        python3 \
        python3-distutils \
        python3-pkg-resources \
        unrar \
        unzip \
        ${EXTRA_INSTALL_ARG} \
    && \
    ln -s /usr/bin/python3 /usr/bin/python \
    && \
    curl -fsSL "https://github.com/sabnzbd/sabnzbd/releases/download/${VERSION}/SABnzbd-${VERSION}-src.tar.gz" | tar xzf - -C /app --strip-components=1 \
    && \
    pip3 install --no-cache-dir -U -r /app/requirements.txt \
    && \
    NZBNOTIFY_VERSION=$(curl -fsSL "https://api.github.com/repos/caronc/nzb-notify/releases/latest" | jq --raw-output '.tag_name') \
    && \
    mkdir -p /app/nzbnotify \
    && \
    curl -fsSL -o /tmp/nzbnotify.tar.gz \
        "https://api.github.com/repos/caronc/nzb-notify/tarball/${NZBNOTIFY_VERSION}" \
    && \
    tar xf \
        /tmp/nzbnotify.tar.gz -C \
        /app/nzbnotify --strip-components=1\
    && \
    cd /app/nzbnotify \
    && \
    pip3 install --no-cache-dir -U -r requirements.txt \
    && apt-get remove -y ${EXTRA_INSTALL_ARG} \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
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

COPY ./apps/sabnzbd/sabnzbd.ini /app/sabnzbd.ini

COPY ./apps/sabnzbd/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="SABnzbd" \
    org.opencontainers.image.source="https://github.com/sabnzbd/sabnzbd" \
    org.opencontainers.image.version="${VERSION}"
