FROM public.ecr.aws/docker/library/node:16-alpine as builder

ARG CHANNEL

WORKDIR /tmp/rallly
#hadolint ignore=DL3018
RUN apk add --no-cache git \
    && git clone --branch ${CHANNEL} --depth 1 https://github.com/lukevella/rallly . \
    && cp sample.env .env \
    && cp prisma/schema.prisma . \
    && yarn --frozen-lockfile \
    && yarn build


FROM ghcr.io/onedr0p/alpine:rolling@sha256:35dc08b62b80ebd6d9a4e46ff1c4503967d4c0ca6a9ca8b04e299102b0319bf6
COPY --from=builder /tmp/rallly .
RUN apk add --no-cache yarn
ENV \
    DATABASE_URL=postgres://postgres:postgres@localhost:5432/db \
    NEXT_PUBLIC_BASE_URL=http://localhost:3000 \
    SECRET_PASSWORD=minimum-32-characters \
    SUPPORT_EMAIL=foo@yourdomain.com \
    SMTP_HOST=your-smtp-server \
    SMTP_PORT=587 \
    SMTP_SECURE=false \
    SMTP_USER=your-smtp-user \
    SMTP_PWD=your-smtp-password
USER kah
CMD sh -c "yarn start"
LABEL org.opencontainers.image.source="https://github.com/lukevella/rallly"
