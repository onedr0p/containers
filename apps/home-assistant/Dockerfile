FROM ghcr.io/onedr0p/alpine:rolling@sha256:d7f6c7fb07ad7b70a54ee1a1aef8f74b62f9a7959821ae103593224624f09c07

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONPATH="${PYTHONPATH}:/pip-packages" \
    WHEELS_LINKS="https://wheels.home-assistant.io/musllinux/" \
    HOME="/config"

ENV HOME_ASSISTANT__HACS_INSTALL="false"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /tmp

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        ca-certificates \
        bluez \
        bluez-deprecated \
        bluez-libs \
        cups-libs \
        eudev-libs \
        ffmpeg \
        git \
        libcap \
        libjpeg-turbo \
        libstdc++ \
        libxslt \
        mariadb-connector-c \
        mariadb-connector-c-dev \
        openssh-client \
        openssl \
        postgresql-libs \
        py3-pip \
        python3 \
        tiff
#hadolint ignore=DL3018,DL3013
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') \
            export ARCH='amd64'; \
        ;; \
        'linux/arm64') \
            export ARCH='aarch64'; \
        ;; \
    esac \
    && \
    HOME_ASSISTANT_BASE=$(curl -fsSL "https://raw.githubusercontent.com/home-assistant/core/${VERSION}/build.yaml" | grep "${ARCH}: " | cut -d ":" -f3) \
    && \
    apk add --no-cache --virtual=.build-deps \
        autoconf \
        cargo \
        cmake \
        cups-dev \
        eudev-dev \
        ffmpeg-dev \
        gcc \
        glib-dev \
        g++ \
        libffi-dev \
        jpeg-dev \
        libxml2-dev \
        libxslt-dev \
        make \
        postgresql-dev \
        python3-dev \
        unixodbc-dev \
    && \
    pip install \
        --upgrade \
        --find-links "${WHEELS_LINKS}" \
        cython \
        pip \
        setuptools \
        wheel \
    && \
    curl -fsSL "https://github.com/home-assistant/core/archive/${VERSION}.tar.gz" \
        | tar xzf - -C /tmp --strip-components=1 \
    && \
    mkdir -p /pip-packages \
    && \
    pip install \
        --upgrade \
        --find-links "${WHEELS_LINKS}" \
        --target /pip-packages \
        distlib \
    && \
    NUMPY_VERSION=$(grep "numpy" requirements_all.txt) \
    && \
    pip install \
        --find-links "${WHEELS_LINKS}" \
        "${NUMPY_VERSION}" \
    && \
    pip install \
        --no-index \
        --only-binary=:all: \
        --find-links "${WHEELS_LINKS}" \
        --requirement "https://raw.githubusercontent.com/home-assistant/docker/${HOME_ASSISTANT_BASE}/requirements.txt" \
    && \
    pip install \
        --find-links "${WHEELS_LINKS}" \
        --requirement requirements_all.txt \
    && \
    pip install \
        --find-links "${WHEELS_LINKS}" \
        homeassistant=="${VERSION}" \
    && \
    pip install \
        --find-links "${WHEELS_LINKS}" \
        pycups PySwitchbot \
    && \
    apk del --purge .build-deps \
    && \
    for cleanfiles in *.pyc *.pyo; \
        do \
        find /usr/lib/python3.* -iname "${cleanfiles}" -exec rm -f '{}' + \
        ; done \
    && \
    rm -rf \
        /root/.cache \
        /root/.cargo \
        /tmp/*

WORKDIR /app
USER kah
COPY ./apps/home-assistant/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/home-assistant/core"
