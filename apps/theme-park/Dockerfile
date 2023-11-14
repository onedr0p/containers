FROM nginxinc/nginx-unprivileged:1.25.3

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

USER root
ENV NGINX_WEB_ROOT "/usr/share/nginx/html"

#hadolint ignore=DL3008
RUN \
    apt-get update -qq \
    && \
    apt-get install -qqy --no-install-recommends --no-install-suggests python3 \
    && \
    curl -fsSL "https://github.com/themepark-dev/theme.park/archive/${VERSION}.tar.gz" \
      | tar xzf - -C /tmp --strip-components 1 \
    && \
    python3 /tmp/themes.py \
    && \
    grep -rl 'https://theme-park.dev' /tmp | xargs sed -i 's/https\:\/\/theme-park.dev//g' \
    && \
    cp -r /tmp/css/ "${NGINX_WEB_ROOT}" \
    && cp -r /tmp/resources/ "${NGINX_WEB_ROOT}" \
    && cp /tmp/index.html "${NGINX_WEB_ROOT}" \
    && apt-get remove -y python3 \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && chown -R nginx:nginx "${NGINX_WEB_ROOT}" \
    && chmod -R 755 "${NGINX_WEB_ROOT}" \
    && rm -rf /tmp/*

USER nginx

WORKDIR ${NGINX_WEB_ROOT}

LABEL org.opencontainers.image.source="https://github.com/themepark-dev/theme.park"
