FROM fluent/fluentd:v1.7.4-debian-2.0
MAINTAINER Cenozon (https://github.com/cenozon/docker-fluentd)
LABEL description="Fluent ${FLUENT_VERSION} on Ubuntu for shipping logs to Elastic"

ENV DOCKERIZE_VERSION=v0.6.1

COPY ./scripts/bash_profile /home/fluent/.bash_profile
COPY ./scripts/bashrc /home/fluent/.bashrc
COPY ./scripts/vimrc /home/fluent/.vimrc
ADD ./fluent.conf /fluentd/etc/fluent.conf

USER root

RUN set -ex \
  && apt update \
  && apt install -y --no-install-recommends \
    make gcc g++ libc-dev ruby-dev libsystemd0 wget \
  && gem install fluent-plugin-elasticsearch --version 3.5.5 \
  && gem install fluent-plugin-record-modifier --version 2.0.1 \
  && gem install fluent-plugin-s3 --version 1.2.0 \
  && gem install fluent-plugin-systemd --version 1.0.2 \
  && gem sources --clear-all \
  && apt-get purge -y --auto-remove \
    -o APT::AutoRemove::RecommendsImportant=false \
    make gcc g++ libc-dev ruby-dev \
  && ln -sf /usr/bin/vim /usr/bin/vi \
  && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && chown -R fluent:fluent /home/fluent

RUN addgroup --gid 1024 docker-systemd \
  && adduser fluent docker-systemd

USER fluent