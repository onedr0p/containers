FROM ghcr.io/onedr0p/alpine:rolling@sha256:d7f6c7fb07ad7b70a54ee1a1aef8f74b62f9a7959821ae103593224624f09c07

# https://github.com/linuxserver/docker-homeassistant/blob/main/Dockerfile
# https://github.com/home-assistant/docker/blob/master/Dockerfile
# https://github.com/home-assistant/docker-base/blob/master/alpine/Dockerfile
# https://github.com/pypa/pip/issues/10788

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIPFLAGS="--use-deprecated=legacy-resolver --find-links https://wheels.home-assistant.io/musllinux/" \
    PYTHONPATH="${PYTHONPATH}:/pip-packages" \
    HOME="/config"

ENV HOME_ASSISTANT__HACS_INSTALL="false"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /tmp

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        bluez \
        bluez-deprecated \
        bluez-libs \
        ca-certificates \
        cups-libs \
        eudev-libs \
        ffmpeg4 \
        git \
        iperf3 \
        libcap \
        libgpiod \
        libjpeg-turbo \
        libpulse \
        libstdc++ \
        libxslt \
        libzbar \
        mariadb-connector-c \
        mariadb-connector-c-dev \
        nmap \
        openssh-client \
        openssl \
        pianobar \
        postgresql-libs \
        pulseaudio-alsa \
        py3-pip \
        python3 \
        socat \
        tiff \
        xz

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache --virtual=.build-deps \
        autoconf \
        build-base \
        cargo \
        cmake \
        cups-dev \
        eudev-dev \
        ffmpeg4-dev \
        g++ \
        gcc \
        glib-dev \
        jpeg-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        make \
        postgresql-dev \
        python3-dev \
        unixodbc-dev \
    && \
    pip install --upgrade \
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
        --target /pip-packages \
        distlib \
    && \
    NUMPY_VERSION=$(grep "numpy" requirements_all.txt) \
    && \
    pip install "${NUMPY_VERSION}" \
    && \
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
    pip install ${PIPFLAGS} \
        --no-index \
        --only-binary=:all: \
        --requirement "https://raw.githubusercontent.com/home-assistant/docker/${HOME_ASSISTANT_BASE}/requirements.txt" \
    && \
    pip install ${PIPFLAGS} \
        --requirement requirements_all.txt \
    && \
    pip install ${PIPFLAGS} \
        homeassistant=="${VERSION}" \
    && \
    pip install ${PIPFLAGS} \
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
