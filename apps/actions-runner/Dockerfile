ARG VERSION
FROM ghcr.io/actions/actions-runner:${VERSION}

USER root

RUN \
    apt-get update \
    && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        jo \
        jq \
        moreutils \
        unrar \
        unzip \
        wget \
        zip \
    && rm -rf /var/lib/apt/lists/*

USER runner
