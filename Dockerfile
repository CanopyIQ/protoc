FROM eclipse-temurin:17-jdk-focal

ENV PROTOBUF_VERSION=21.7

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
  && curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-all-${PROTOBUF_VERSION}.tar.gz \
  && tar xzf protobuf-all-${PROTOBUF_VERSION}.tar.gz \
  && cd protobuf-${PROTOBUF_VERSION} \
  && ./configure --disable-shared \
  && make \
  && make install \
  && cd \
  && rm -rf /tmp/protobufs/ \
  && mkdir /defs

# Setup directories for the volumes that should be used
WORKDIR /defs

ENTRYPOINT ["protoc"]
