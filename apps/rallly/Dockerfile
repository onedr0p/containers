FROM --platform=linux/amd64 public.ecr.aws/docker/library/node:18-alpine as builder

WORKDIR /tmp/rallly
#hadolint ignore=DL3018
RUN apk add --no-cache git \
    && git clone --depth 1 https://github.com/lukevella/rallly . \
    && cp sample.env .env \
    && cp prisma/schema.prisma . \
    && yarn --frozen-lockfile \
    && yarn build


FROM ghcr.io/onedr0p/alpine:rolling@sha256:e25d6744afe5ae0c03e0b2af4977c2d7df3f56b713c3b5cdffb8c372edf626be
COPY --from=builder /tmp/rallly .
RUN apk add --no-cache yarn
USER kah
CMD sh -c "yarn start"
LABEL org.opencontainers.image.source="https://github.com/lukevella/rallly"
