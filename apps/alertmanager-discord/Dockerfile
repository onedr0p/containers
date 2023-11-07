FROM golang:alpine AS builder
ARG VERSION

WORKDIR /build

# hadolint ignore=DL4006,DL3018,DL3003,SC2164
RUN \
  apk add --no-cache \
    ca-certificates \
    git \
  && git clone https://github.com/benjojo/alertmanager-discord.git $GOPATH/src/mypackage/myapp \
  && adduser -D -g '' appuser
WORKDIR $GOPATH/src/mypackage/myapp/
RUN go get -d -v; \
  CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/alertmanager-discord

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /go/bin/alertmanager-discord /go/bin/alertmanager-discord

ENV LISTEN_ADDRESS=0.0.0.0:9094
EXPOSE 9094
USER appuser
ENTRYPOINT ["/go/bin/alertmanager-discord"]