FROM ghcr.io/joryirving/alpine:rolling@sha256:7bc458290f433489d5e0e8403bf7508ad165f8fba1e28f684273a52c7346efb1

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL
ARG TARGETARCH
ARG TARGETOS

LABEL dev.tparker00.image.target_platform=$TARGETPLATFORM
LABEL dev.tparker00.image.target_architecture=$TARGETARCH
LABEL dev.tparker00.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="https://github.com/Casvt/Kapowarr"

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1

STOPSIGNAL SIGINT
WORKDIR /app

RUN \
    curl -fsSL "https://github.com/Casvt/Kapowarr/archive/${VERSION}.tar.gz" | tar xzf - -C /app --strip-components 1 \
    && \
    echo "${VERSION}" > /app/version.txt \
    && \
    echo "${CHANNEL}" > /app/branch.txt \
    && chown -R 568:568 /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache ca-certificates python3 py3-lxml py3-openssl py3-setuptools \
    && \
    apk add --no-cache --virtual .build-deps py3-pip make gcc g++ python3-dev \
    && \
    pip install --upgrade pip \
    && \
    pip install -r /app/requirements.txt \
    && apk del --purge .build-deps \
    && rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

USER kah

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
