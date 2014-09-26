FROM ubuntu:14.04
MAINTAINER Jason Wilder jwilder@litl.com

RUN apt-get update
RUN apt-get install -y wget python python-pip python-dev libssl-dev
RUN apt-get install -y golang git

RUN mkdir /app
WORKDIR /app

RUN mkdir -p /go/src
ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin

RUN go get github.com/BurntSushi/toml
RUN go build github.com/BurntSushi/toml
RUN go get github.com/fsouza/go-dockerclient
RUN go build github.com/fsouza/go-dockerclient
RUN go get github.com/alexturek/docker-gen
RUN go build github.com/alexturek/docker-gen
RUN go install github.com/alexturek/docker-gen

RUN apt-get install -y libffi-dev
RUN pip install cffi
RUN pip install python-etcd

ADD . /app

ENV DOCKER_HOST unix:///var/run/docker.sock

CMD docker-gen -interval 10 -watch -notify "python /tmp/register.py" etcd.tmpl /tmp/register.py
