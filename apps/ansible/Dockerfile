FROM ubuntu:2204

ENV DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3008,DL3009
RUN apt-get update && \
  apt-get install --no-install-suggests --no-install-recommends --yes gcc python3-dev libkrb5-dev python3-pip krb5-user && \
  pip3 install --upgrade --disable-pip-version-check --no-cache-dir -r /requirements.txt
