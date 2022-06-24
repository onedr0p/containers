FROM ghcr.io/onedr0p/alpine:rolling@sha256:05007e71bc03db450ca455f02efd74ce69b4a6ca18340fe6d3ef5703e79d2351

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
    curl -fsSL -o /tmp/nzbget.run \
      "https://github.com/nzbget/nzbget/releases/download/v${VERSION}/nzbget-${VERSION}-bin-linux.run" \
    && \
    sh /tmp/nzbget.run --destdir /app \
    && \
    curl -fsSL "https://curl.se/ca/cacert.pem" | sed '/^DST Root CA X3$/,/^-----END CERTIFICATE-----$/d;' > "/app/cacert.pem" \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

#hadolint ignore=DL3013,DL3018
RUN \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.14/main unrar \
    && \
    apk add --no-cache p7zip python3 py3-lxml unrar unzip \
    && \
    apk add --no-cache --virtual .build-deps py3-pip \
    && \
    pip3 install --no-cache-dir --upgrade pip \
    && \
    pip3 install --no-cache-dir --upgrade \
      apprise \
      chardet \
      pynzbget \
      rarfile \
    && apk del --purge .build-deps \
    && rm -rf /tmp/*

USER kah
COPY ./apps/nzbget/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="NZBGet ($STREAM)" \
  org.opencontainers.image.source="https://github.com/nzbget/nzbget" \
  org.opencontainers.image.version="${VERSION}"


# # hadolint ignore=DL3008,DL3013,DL3015,SC2086
# RUN \
#   export EXTRA_INSTALL_ARG="build-essential libxml2-dev libxslt1-dev python3-dev python3-pip"; \
#   apt-get -qq update \
#   && \
#   apt-get -qq install -y \
#     p7zip-full \
#     python3 \
#     unrar \
#     unzip \
#     wget \
#     ${EXTRA_INSTALL_ARG} \
#   && \
#   pip3 install --no-cache-dir -U \
#     apprise \
#     chardet \
#     pynzbget \
#     rarfile \
#   && \
#   ln -s /usr/bin/python3 /usr/bin/python \
#   && \
#   curl -fsSL -o /tmp/nzbget.run \
#     "https://github.com/nzbget/nzbget/releases/download/v${VERSION}/nzbget-${VERSION}-bin-linux.run" \
#   && \
#   sh /tmp/nzbget.run --destdir /app \
#   && \
#   apt-get remove -y ${EXTRA_INSTALL_ARG} \
#   && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
#   && apt-get autoremove -y \
#   && apt-get clean \
#   && \
#   rm -rf \
#     /tmp/* \
#     /var/lib/apt/lists/* \
#     /var/tmp/ \
#   && curl -fsSl -o /app/cacert.pem -L "https://curl.haxx.se/ca/cacert.pem" \
#   && chown -R kah:kah /app \
#   && chmod -R u=rwX,go=rX /app \
#   && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

# USER kah

# EXPOSE 6789

# COPY ./apps/nzbget/entrypoint.sh /entrypoint.sh
# CMD ["/entrypoint.sh"]

# LABEL \
#   org.opencontainers.image.title="NZBGet" \
#   org.opencontainers.image.source="https://github.com/nzbget/nzbget" \
#   org.opencontainers.image.version="${VERSION}"
