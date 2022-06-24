FROM ghcr.io/onedr0p/alpine:rolling@sha256:05007e71bc03db450ca455f02efd74ce69b4a6ca18340fe6d3ef5703e79d2351

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
    curl -fsSL "https://github.com/sabnzbd/sabnzbd/releases/download/${VERSION}/SABnzbd-${VERSION}-src.tar.gz" \
        | tar xzf - -C /app --strip-components=1 \
    && \
    NZBNOTIFY_VERSION=$(curl -fsSL "https://api.github.com/repos/caronc/nzb-notify/releases/latest" | jq --raw-output '.tag_name') \
    && \
    mkdir -p /app/nzbnotify \
    && \
    curl -fsSL "https://api.github.com/repos/caronc/nzb-notify/tarball/${NZBNOTIFY_VERSION}" \
        | tar xzf - -C /app/nzbnotify --strip-components=1 \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache python3 par2cmdline && \
    apk add --no-cache --virtual=build-dependencies \
        build-base \
        libffi-dev \
        openssl-dev \
        musl-dev \
        cargo \
        python3-dev \
        py3-pip \
    && \
    pip3 install --no-cache-dir --upgrade --requirement /app/requirements.txt \
    && pip3 install --no-cache-dir --upgrade --requirement /app/nzbnotify/requirements.txt \
    && apk del --purge build-dependencies \
    && rm -rf /tmp/*

USER kah
COPY ./apps/sabnzbd/sabnzbd.ini /app/sabnzbd.ini
COPY ./apps/sabnzbd/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="SABnzbd" \
    org.opencontainers.image.source="https://github.com/sabnzbd/sabnzbd" \
    org.opencontainers.image.version="${VERSION}"
