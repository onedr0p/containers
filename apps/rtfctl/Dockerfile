FROM alpine:3.18.2

ARG VERSION
ENV ENV_VERSION=${VERSION}

ADD https://anypoint.mulesoft.com/runtimefabric/api/download/rtfctl/${ENV_VERSION} /usr/local/bin/rtfctl

# hadolint ignore=DL3018,DL3017
RUN apk --no-cache upgrade && \
    apk --no-cache add ca-certificates && \
    chmod +x /usr/local/bin/rtfctl
