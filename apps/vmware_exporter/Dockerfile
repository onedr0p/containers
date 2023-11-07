FROM golang:alpine AS builder
ARG VERSION

WORKDIR /build

# hadolint ignore=DL4006,DL3018,DL3003,SC2164
RUN \
  apk add --no-cache git; \
  git clone https://github.com/pryorda/vmware_exporter.git /upstream \
  && if [ -n "${VERSION}" ]; then \
  ( cd /upstream/; \
  git checkout tags/v${VERSION}); \
  fi 

FROM python:3.12-alpine

WORKDIR /opt/vmware_exporter/
COPY --from=builder /upstream/ /opt/vmware_exporter/
# hadolint ignore=DL3018,DL3017,SC2086,DL3013
RUN set -x; buildDeps="gcc python3-dev musl-dev libffi-dev openssl openssl-dev rust cargo" \
 && apk add --no-cache --update $buildDeps \
 && pip install --no-cache-dir -r requirements.txt . \
 && pip install --no-cache-dir requests \
 && apk del $buildDeps

EXPOSE 9272

ENV PYTHONUNBUFFERED=1

ENTRYPOINT ["/usr/local/bin/vmware_exporter"]