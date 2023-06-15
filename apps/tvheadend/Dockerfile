FROM ghcr.io/onedr0p/alpine:3.17.3 as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV ARGTABLE_VER="2.13"
ENV XMLTV_VER="v1.1.2"
ENV HOME="/config"

COPY ./apps/tvheadend/patches/ /tmp/patches/

RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export EXTRA_PACKAGES='libva-dev' ;; \
        'linux/arm64') export EXTRA_PACKAGES='' ;; \
    esac \
    && \
    apk add --no-cache \
        ${EXTRA_PACKAGES} \
        autoconf \
        automake \
        bsd-compat-headers \
        bzip2 \
        cmake \
        coreutils \
        curl \
        ffmpeg4-dev \
        file \
        findutils \
        g++ \
        gcc \
        gettext-dev \
        git \
        gnu-libiconv-dev \
        gzip \
        jq \
        libcurl \
        libdvbcsa-dev \
        libgcrypt-dev \
        libhdhomerun-dev \
        libtool \
        libvpx-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        make \
        openssl-dev \
        opus-dev \
        patch \
        pcre2-dev \
        perl-archive-zip \
        perl-boolean \
        perl-capture-tiny \
        perl-cgi \
        perl-compress-raw-zlib \
        perl-date-manip \
        perl-datetime \
        perl-datetime-format-strptime \
        perl-datetime-timezone \
        perl-dbd-sqlite \
        perl-dbi \
        perl-dev \
        perl-digest-sha1 \
        perl-doc \
        perl-file-slurp \
        perl-file-temp \
        perl-file-which \
        perl-getopt-long \
        perl-html-parser \
        perl-html-tree \
        perl-http-cookies \
        perl-io \
        perl-io-html \
        perl-io-socket-ssl \
        perl-io-stringy \
        perl-json \
        perl-json-xs \
        perl-libwww \
        perl-lingua-en-numbers-ordinate \
        perl-lingua-preferred \
        perl-list-moreutils \
        perl-lwp-useragent-determined \
        perl-module-build \
        perl-module-pluggable \
        perl-net-ssleay \
        perl-parse-recdescent \
        perl-path-class \
        perl-scalar-list-utils \
        perl-term-progressbar \
        perl-term-readkey \
        perl-test-exception \
        perl-test-requires \
        perl-timedate \
        perl-try-tiny \
        perl-unicode-string \
        perl-xml-libxml \
        perl-xml-libxslt \
        perl-xml-parser \
        perl-xml-sax \
        perl-xml-treepp \
        perl-xml-twig \
        perl-xml-writer \
        pkgconf \
        pngquant \
        python3 \
        sdl12-compat-dev \
        tar \
        uriparser-dev \
        wget \
        x264-dev \
        x265-dev \
        zlib-dev

RUN \
    rm -rf /usr/include/iconv.h \
    && cp /usr/include/gnu-libiconv/iconv.h /usr/include/iconv.h

RUN \
    curl -fsSL https://cpanmin.us | perl - App::cpanminus \
    && cpanm --installdeps /tmp/patches

WORKDIR /tmp/xmltv
RUN \
    git clone --branch "${XMLTV_VER}" --depth 1 https://github.com/XMLTV/xmltv.git . \
    && sed "s/use POSIX 'tmpnam';//" -i filter/tv_to_latex \
    && sed "s/use POSIX 'tmpnam';//" -i filter/tv_to_text \
    && sed "s/\(lib\/set_share_dir.pl';\)/.\/\1/" -i grab/it/tv_grab_it.PL \
    && sed "s/\(filter\/Grep.pm';\)/.\/\1/" -i filter/tv_grep.PL \
    && sed "s/\(lib\/XMLTV.pm.in';\)/.\/\1/" -i lib/XMLTV.pm.PL \
    && sed "s/\(lib\/Ask\/Term.pm';\)/.\/\1/" -i Makefile.PL \
    && export PERL5LIB="$(pwd)" \
    && echo -e "yes" | perl Makefile.PL PREFIX=/usr/ INSTALLDIRS=vendor \
    && make -j $(nproc) \
    && make test \
    && make DESTDIR=/tmp/xmltv-build install

WORKDIR /tmp/tvheadend
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export EXTRA_OPTS='--enable-vaapi' ;; \
        'linux/arm64') export EXTRA_OPTS='' ;; \
    esac \
    && \
    git clone https://github.com/tvheadend/tvheadend.git . \
    && \
    if [ -n "${VERSION}" ]; then \
        NUMBER_COMMITS_TO_REVERT=$(( $(git rev-list --count --first-parent HEAD) - $(echo "${VERSION}" | cut -d "." -f3) )); \
        git checkout "master~${NUMBER_COMMITS_TO_REVERT}"; \
    fi \
    && \
    ./configure \
        `#Encoding` \
        --disable-ffmpeg_static \
        --disable-libfdkaac_static \
        --disable-libtheora_static \
        --disable-libopus_static \
        --disable-libvorbis_static \
        --disable-libvpx_static \
        --disable-libx264_static \
        --disable-libx265_static \
        --disable-libfdkaac \
        --enable-libopus \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libx264 \
        --enable-libx265 \
        \
        `#Options` \
        --disable-avahi \
        --disable-dbus_1 \
        --disable-bintray_cache \
        --disable-execinfo \
        --disable-hdhomerun_static \
        --enable-hdhomerun_client \
        --enable-libav \
        --enable-pngquant \
        --enable-trace \
        ${EXTRA_OPTS} \
        --infodir=/usr/share/info \
        --localstatedir=/var \
        --mandir=/usr/share/man \
        --prefix=/usr \
        --python=python3 \
        --sysconfdir=/config \
    && make -j $(nproc) \
    && make DESTDIR=/tmp/tvheadend-build install

WORKDIR /tmp/argtable
RUN \
    ARGTABLE_VER1="${ARGTABLE_VER//./-}" \
    && \
    curl -fsSL "https://sourceforge.net/projects/argtable/files/argtable/argtable-${ARGTABLE_VER}/argtable${ARGTABLE_VER1}.tar.gz" \
        | tar xzf - -C . --strip-components=1 \
    && cp /tmp/patches/config.* . \
    && ./configure --prefix=/usr \
    && make -j $(nproc) \
    && make check \
    && make DESTDIR=/tmp/argtable-build install \
    && cp -pr /tmp/argtable-build/usr/* /usr/

WORKDIR /tmp/comskip
RUN \
    git clone --depth 1 https://github.com/erikkaashoek/Comskip . \
    && ./autogen.sh \
    && ./configure --bindir=/usr/bin --sysconfdir=/config/comskip \
    && make -j $(nproc) \
    && make DESTDIR=/tmp/comskip-build install

FROM ghcr.io/onedr0p/alpine:3.17.3

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV HOME="/config"

RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export EXTRA_PACKAGES='libva libva-intel-driver intel-media-driver' ;; \
        'linux/arm64') export EXTRA_PACKAGES='' ;; \
    esac \
    && \
    apk add --no-cache \
        ${EXTRA_PACKAGES} \
        bsd-compat-headers \
        bzip2 \
        curl \
        ffmpeg4 \
        ffmpeg4-libs \
        gnu-libiconv \
        gzip \
        libcrypto1.1 \
        libcurl \
        libdvbcsa \
        libhdhomerun-libs \
        libssl1.1 \
        libvpx \
        libxml2 \
        libxslt \
        linux-headers \
        openssl \
        opus \
        pcre2 \
        perl \
        perl-archive-zip \
        perl-boolean \
        perl-capture-tiny \
        perl-cgi \
        perl-compress-raw-zlib \
        perl-date-manip \
        perl-datetime \
        perl-datetime-format-strptime \
        perl-datetime-timezone \
        perl-dbd-sqlite \
        perl-dbi \
        perl-digest-sha1 \
        perl-doc \
        perl-file-slurp \
        perl-file-temp \
        perl-file-which \
        perl-getopt-long \
        perl-html-parser \
        perl-html-tree \
        perl-http-cookies \
        perl-io \
        perl-io-html \
        perl-io-socket-ssl \
        perl-io-stringy \
        perl-json \
        perl-json-xs \
        perl-libwww \
        perl-lingua-en-numbers-ordinate \
        perl-lingua-preferred \
        perl-list-moreutils \
        perl-lwp-useragent-determined \
        perl-module-build \
        perl-module-pluggable \
        perl-net-ssleay \
        perl-parse-recdescent \
        perl-path-class \
        perl-scalar-list-utils \
        perl-term-progressbar \
        perl-term-readkey \
        perl-test-exception \
        perl-test-requires \
        perl-timedate \
        perl-try-tiny \
        perl-unicode-string \
        perl-xml-libxml \
        perl-xml-libxslt \
        perl-xml-parser \
        perl-xml-sax \
        perl-xml-treepp \
        perl-xml-twig \
        perl-xml-writer \
        py3-requests \
        python3 \
        tar \
        uriparser \
        wget \
        x264 \
        x265 \
        zlib

RUN \
    mkdir -p /app/picons \
    && curl -fsSL "https://lsio-ci.ams3.digitaloceanspaces.com/picons/picons.tar.bz2" \
        | tar xjf - -C /app/picons \
    && \
    chown -R root:root /app \
    && chmod -R 755 /app \
    && rm -rf /tmp/*

COPY ./apps/tvheadend/bin /usr/bin/
COPY --from=builder /tmp/argtable-build/usr/ /usr/
COPY --from=builder /tmp/comskip-build/usr/ /usr/
COPY --from=builder /tmp/tvheadend-build/usr/ /usr/
COPY --from=builder /tmp/xmltv-build/usr/ /usr/
COPY --from=builder /usr/local/share/man/ /usr/local/share/man/
COPY --from=builder /usr/local/share/perl5/ /usr/local/share/perl5/

USER kah
COPY ./apps/tvheadend/defaults /app/defaults
COPY ./apps/tvheadend/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/tvheadend/tvheadend"
