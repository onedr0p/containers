FROM ghcr.io/onedr0p/ubuntu-focal:rolling@sha256:72de8714ed3958baa0843658d58e574dda22cbf297d97d7e36da74483aa856c7

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG STREAM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    libicu66 \
    libssl1.1 \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='AMDx64' ;; \
    'linux/arm64') export ARCH='ARM64' ;; \
    'linux/arm/v7') export ARCH='ARM32' ;; \
  esac \
  && \
  curl -fsSL -o /tmp/jackett.tar.gz \
    "https://github.com/Jackett/Jackett/releases/download/v${VERSION}/Jackett.Binaries.Linux${ARCH}.tar.gz" \
  && tar ixzf /tmp/jackett.tar.gz -C /app --strip-components 1 \
  && \
  rm -rf \
    /app/JackettUpdater* \
  && \
  apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
      /tmp/* \
      /var/lib/apt/lists/* \
      /var/tmp/ \
  && chown -R root:root /app \
  && chmod -R 755 /app \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER kah
COPY ./apps/jackett/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="Jackett" \
  org.opencontainers.image.source="https://github.com/Jackett/Jackett" \
  org.opencontainers.image.version="${VERSION}"
