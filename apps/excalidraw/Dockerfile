ARG VERSION
FROM public.ecr.aws/docker/library/node:19-alpine as builder
ARG VERSION
WORKDIR /tmp/excalidraw
#hadolint ignore=DL3018
RUN apk add --no-cache git \
    && git clone --branch "v${VERSION}" --depth 1 https://github.com/excalidraw/excalidraw .
RUN yarn --ignore-optional
ENV NODE_ENV=production
RUN yarn build:app:docker

FROM nginxinc/nginx-unprivileged:1.23.1

ARG VERSION
ARG CHANNEL

USER nginx
WORKDIR /usr/share/nginx/html
COPY --from=builder /tmp/excalidraw/build .

LABEL org.opencontainers.image.source="https://github.com/excalidraw/excalidraw"
