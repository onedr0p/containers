FROM public.ecr.aws/docker/library/alpine:3.18.0
USER root
ARG TARGETARCH
ARG VERSION
RUN apk add --no-cache --virtual .build-deps curl \
    && mkdir /plugins \
    && \
    curl -fsSL "https://github.com/containernetworking/plugins/releases/download/v${VERSION}/cni-plugins-linux-${TARGETARCH}-v${VERSION}.tgz" \
        | tar xzf - -C /plugins \
    && apk del --purge .build-deps \
    && rm -rf /tmp/*
CMD cp /plugins/* /host/opt/cni/bin
