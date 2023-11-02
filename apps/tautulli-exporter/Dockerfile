FROM golang:alpine AS builder
ARG VERSION

WORKDIR /build

# hadolint ignore=DL4006,DL3018
RUN \
  apk add --no-cache \
    gcc \
    git \
    musl-dev \
    linux-headers \
  && git clone https://github.com/nwalke/tautulli-exporter.git . \
  && if [ -n "${VERSION}" ]; then \
  git checkout tags/v${VERSION}; \
  fi \
  && go mod init tautulli_exporter.go; \
  go mod tidy; \
  CGO_ENABLED=0 go build -a -installsuffix cgo -ldflags "-w -s -X main.version=${VERSION}" -o /bin/tautulli_exporter

FROM scratch
WORKDIR /app/
COPY --from=builder /bin/tautulli_exporter .
EXPOSE 9487/tcp
ENTRYPOINT ["./tautulli_exporter"]
