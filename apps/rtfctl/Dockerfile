FROM alpine:3.18.2

ARG VERSION

# hadolint ignore=DL3018,DL3017
RUN apk --no-cache upgrade && \
    apk --no-cache add ca-certificates curl && \
    curl -L https://anypoint.mulesoft.com/runtimefabric/api/download/rtfctl/${VERSION} -o /usr/local/bin/rtfctl && \
    chmod +x /usr/local/bin/rtfctl

USER abc