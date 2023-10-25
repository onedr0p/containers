FROM public.ecr.aws/docker/library/alpine:3.18.4

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates sqlite~"${VERSION}"

CMD [ "/usr/bin/sqlite3" ]

LABEL org.opencontainers.image.source="https://github.com/sqlite/sqlite"
