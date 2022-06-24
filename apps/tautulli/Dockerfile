FROM ghcr.io/onedr0p/alpine:rolling@sha256:05007e71bc03db450ca455f02efd74ce69b4a6ca18340fe6d3ef5703e79d2351

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

ENV TAUTULLI_DOCKER="True"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
    curl -fsSL "https://github.com/Tautulli/Tautulli/archive/v${VERSION}.tar.gz" | tar xzf - -C /app --strip-components 1 \
    && \
    echo "v${VERSION}" > /app/version.txt \
    && \
    echo "${STREAM}" > /app/branch.txt \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache python3 py3-lxml py3-openssl py3-setuptools \
    && \
    apk add --no-cache --virtual .build-deps py3-pip make gcc g++ python3-dev \
    && \
    pip3 install --no-cache-dir --upgrade \
        plexapi \
        pycryptodomex \
    && apk del --purge .build-deps \
    && rm -rf /tmp/*

USER kah
COPY ./apps/tautulli/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
    org.opencontainers.image.title="Tautulli ($STREAM)" \
    org.opencontainers.image.source="https://github.com/Tautulli/Tautulli" \
    org.opencontainers.image.version="${VERSION}"
