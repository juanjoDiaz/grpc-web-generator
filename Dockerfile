FROM ubuntu:16.04

ARG MAKEFLAGS=-j8

RUN apt-get update && apt-get install -y \
  automake \
  build-essential \
  git \
  libtool \
  make

RUN git clone https://github.com/grpc/grpc-web /github/grpc-web

## Install gRPC and protobuf

RUN cd /github/grpc-web && \
  ./scripts/init_submodules.sh

RUN cd /github/grpc-web/third_party/grpc && \
  make && make install

RUN cd /github/grpc-web/third_party/grpc/third_party/protobuf && \
  make install

## Install all the gRPC-web plugin

RUN cd /github/grpc-web && \
  make install-plugin

RUN rm -rf /github

## Create the gRPC client
ENV import_style=commonjs
ENV grpc-web_import_style=commonjs
ENV mode=grpcwebtext
VOLUME /protofile
ENV protofile=echo.proto
ENV output=/protofile/generated

CMD rm -rf $output && \
  mkdir $output && \
  protoc \
  -I=/protofile \
  /protofile/$protofile \
  --js_out=import_style=$import_style:$output \
  --grpc-web_out=import_style=$grpc-web_import_style,mode=$mode:$output
