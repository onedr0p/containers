ARG VERSION
FROM --platform=amd64 ghcr.io/actions/actions-runner:${VERSION}

ENV HOMEBREW_NO_ANALYTICS=1 \
    HOMEBREW_NO_ENV_HINTS=1 \
    HOMEBREW_NO_INSTALL_CLEANUP=1

USER root

RUN \
    apt-get update \
    && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gcc \
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

# https://stackoverflow.com/questions/72435188/how-to-install-brew-using-a-shallow-clone-especially-useful-in-ci-systems
RUN curl -fsSL -o install-brew.sh \
        "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh" \
    && sed -i 's|"git" "fetch"|"git" "fetch" "--depth" "1"|' ./install-brew.sh \
    && sed -i '/"update" "--force"/d' ./install-brew.sh \
    && HOMEBREW_NO_AUTO_UPDATE=1 bash ./install-brew.sh \
    && rm -rf install-brew.sh
