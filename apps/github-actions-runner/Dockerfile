FROM mcr.microsoft.com/dotnet/runtime-deps:7.0-jammy@sha256:5e419d42a062f28746e08e00fcddba5f89cc3ce19707ea0ef0bb81147458bc53

ARG VERSION
# renovate: datasource=github-releases depName=actions/runner-container-hooks
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.3.2
ARG DOCKER_VERSION=20.10.23

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV RUNNER_MANUALLY_TRAP_SIG=1
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1

RUN \
    # Prerequisites
    set -eux \
    && apt-get -qq update \
    && apt-get install -y \
        bash \
        ca-certificates \
        curl \
        git \
        jo \
        jq \
        locales \
        moreutils \
        sudo \
        tzdata \
        unrar \
        unzip \
        wget \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' && export DOCKER_ARCH='x86_64' ;; \
        'linux/arm64') export ARCH='arm64' && export DOCKER_ARCH='aarch64' ;; \
    esac \
    && \
    # Prepare user
    adduser --disabled-password --gecos "" --uid 1001 runner \
    && groupadd docker --gid 123 \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers \
    && \
    # Install Runner
    cd /home/runner \
    && \
    curl -fsSL -o runner.tar.gz "https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-linux-${ARCH}-${VERSION}.tar.gz" \
        && tar xzf ./runner.tar.gz \
        && rm runner.tar.gz \
    && \
    curl -fsSL -o runner-container-hooks.zip https://github.com/actions/runner-container-hooks/releases/download/v${RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-k8s-${RUNNER_CONTAINER_HOOKS_VERSION}.zip \
        && unzip ./runner-container-hooks.zip -d ./k8s \
        && rm runner-container-hooks.zip \
    && \
    # Install Docker
    curl -fsSL -o docker.tgz https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz \
        && tar zxvf docker.tgz \
        && rm -rf docker.tgz \
        && chown -R runner:docker . \
        && install -o root -g root -m 755 docker/* /usr/bin/ \
        && rm -rf docker \
    && \
    # Cleanup
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /var/tmp/*

WORKDIR /home/runner
USER runner
CMD ["/home/runner/run.sh"]
