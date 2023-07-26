FROM alpine:3.18.2

ARG VERSION

# hadolint ignore=DL3018,DL3017
RUN apk --no-cache upgrade && \
    apk --no-cache add ca-certificates curl && \
    adduser -D abc

ADD --chown=abc:abc --chmod=755 https://anypoint.mulesoft.com/runtimefabric/api/download/rtfctl/${VERSION} /usr/local/bin/rtfctl

USER 1000
