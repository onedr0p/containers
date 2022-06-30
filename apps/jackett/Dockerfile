FROM ghcr.io/onedr0p/ubuntu:rolling@sha256:a0c4a4b02ef13de4c7a83b21ce1ad0f73b43f0c913c1566a39d510360156a4fd as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV XDG_CONFIG_HOME=/config

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

LABEL org.opencontainers.image.source="https://github.com/Jackett/Jackett"
