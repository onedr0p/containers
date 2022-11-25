FROM --platform=linux/amd64 public.ecr.aws/docker/library/node:18-alpine as builder

WORKDIR /tmp/rallly
#hadolint ignore=DL3018
RUN apk add --no-cache git \
    && git clone --depth 1 https://github.com/lukevella/rallly . \
    && cp sample.env .env \
    && cp prisma/schema.prisma . \
    && yarn --frozen-lockfile \
    && yarn build


FROM ghcr.io/onedr0p/alpine:rolling@sha256:236a079145da5ce82269346534cacc8483ddaa8ff1aa4feaaf3a1bf6fb4d1cda
COPY --from=builder /tmp/rallly .
RUN apk add --no-cache yarn
USER kah
CMD sh -c "yarn start"
LABEL org.opencontainers.image.source="https://github.com/lukevella/rallly"
