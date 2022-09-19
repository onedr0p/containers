FROM --platform=linux/amd64 public.ecr.aws/docker/library/node:16-alpine as builder

WORKDIR /tmp/rallly
#hadolint ignore=DL3018
RUN apk add --no-cache git \
    && git clone --depth 1 https://github.com/lukevella/rallly . \
    && cp sample.env .env \
    && cp prisma/schema.prisma . \
    && yarn --frozen-lockfile \
    && yarn build


FROM ghcr.io/onedr0p/alpine:rolling@sha256:35dc08b62b80ebd6d9a4e46ff1c4503967d4c0ca6a9ca8b04e299102b0319bf6
COPY --from=builder /tmp/rallly .
RUN apk add --no-cache yarn
USER kah
CMD sh -c "yarn start"
LABEL org.opencontainers.image.source="https://github.com/lukevella/rallly"
