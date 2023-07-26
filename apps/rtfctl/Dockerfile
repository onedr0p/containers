FROM alpine:3.18.2

ARG VERSION
ENV ENV_VERSION=${VERSION}

# hadolint ignore=DL3018,DL3017
RUN apk --no-cache upgrade && \
    apk --no-cache add ca-certificates \
    adduser -D abc -u 1000

ADD --chown=1000:1000 --chmod=755 https://anypoint.mulesoft.com/runtimefabric/api/download/rtfctl/${ENV_VERSION} /usr/local/bin/rtfctl

USER 1000