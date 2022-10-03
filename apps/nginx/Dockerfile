FROM nginxinc/nginx-unprivileged:1.23.1

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
ARG CHANNEL

USER root
ENV NGINX_WEB_ROOT "/usr/share/nginx/html"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER nginx

WORKDIR ${NGINX_WEB_ROOT}

#LABEL org.opencontainers.image.source="https://github.com/GilbN/theme.park"
