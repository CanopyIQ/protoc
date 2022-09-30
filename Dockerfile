FROM eclipse-temurin:17-jdk-focal

# Install bazel, needed to build Protoc
ARG TARGETARCH

RUN apt-get update && apt-get install -y wget

RUN if [ "$TARGETARCH" = "arm64" ]; then \
        wget -O bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.14.0/bazelisk-linux-arm64; \
    else  \
        wget -O bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.14.0/bazelisk-linux-amd64; \
    fi

RUN chmod +x bazelisk && mv bazelisk /usr/local/bin/bazel

ENV PROTOBUF_VERSION=3.20.1

# Install Protoc
################
RUN set -ex \
  && apt-get update  \
  && apt-get install -y \
  make \
  cmake \
  autoconf \
  automake \
  curl \
  tar \
  libtool \
  g++ \
  git \
  \
  && mkdir -p /tmp/protobufs \
  && cd /tmp/protobufs \
  && git clone -b v${PROTOBUF_VERSION} https://github.com/google/protobuf.git \
  && cd protobuf \
  && git submodule update --init --recursive \
  && bazel build :protoc :protobuf \
  && cp bazel-bin/protoc /usr/local/bin \
  && cd \
  && rm -rf /tmp/protobufs/ \
  && mkdir /defs

# Setup directories for the volumes that should be used
WORKDIR /defs

ENTRYPOINT ["protoc"]
