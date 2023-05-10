# based on https://4sysops.com/archives/how-to-deploy-ansible-inside-a-docker-container/
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

COPY ./apps/ansible/requirements.txt /

# hadolint ignore=DL3008,DL3009
RUN apt-get update && \
  apt-get install --no-install-suggests --no-install-recommends --yes gcc python3-dev libkrb5-dev python3-pip krb5-user && \
  pip3 install --upgrade --disable-pip-version-check --no-cache-dir -r /requirements.txt && \
  useradd -ms /bin/bash ansible

USER ansible
WORKDIR /home/ansible
