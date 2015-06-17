FROM ubuntu:14.04
MAINTAINER Jason Wilder jwilder@litl.com

RUN apt-get update
RUN apt-get install -y wget bash

RUN wget https://github.com/jwilder/docker-gen/releases/download/0.3.3/docker-gen-linux-amd64-0.3.3.tar.gz
RUN tar xvzf docker-gen-linux-amd64-0.3.3.tar.gz -C /usr/local/bin

RUN wget https://github.com/coreos/etcd/releases/download/v2.0.12/etcd-v2.0.12-linux-amd64.tar.gz
RUN tar xvzf etcd-v2.0.12-linux-amd64.tar.gz && mv etcd-v2.0.12-linux-amd64/etcdctl /usr/local/bin

RUN mkdir /app
ADD etcd.tmpl /app/

ENV DOCKER_HOST unix:///var/run/docker.sock

CMD docker-gen -interval 10 -watch -notify "bash /tmp/register.sh" /app/etcd.tmpl /tmp/register.sh
