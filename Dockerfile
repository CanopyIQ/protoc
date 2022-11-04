FROM eclipse-temurin:17-jdk-focal

ENV PROTOBUF_VERSION=21.7
ENV PROTOC_DOC_GEN_VERSION=1.5.1
ARG TARGETARCH

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
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && cd \
  && rm -rf /tmp/protobufs/ \
  && mkdir /defs

# Install docgen plugin
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      curl -L -o protoc-gen-doc.tar.gz https://github.com/pseudomuto/protoc-gen-doc/releases/download/v${PROTOC_DOC_GEN_VERSION}/protoc-gen-doc_${PROTOC_DOC_GEN_VERSION}_linux_amd64.tar.gz; \
    else \
      curl -L -o protoc-gen-doc.tar.gz https://github.com/pseudomuto/protoc-gen-doc/releases/download/v${PROTOC_DOC_GEN_VERSION}/protoc-gen-doc_${PROTOC_DOC_GEN_VERSION}_linux_arm64.tar.gz; \
    fi \
    && tar xzf protoc-gen-doc.tar.gz \
    && chmod +x protoc-gen-doc \
    && mv protoc-gen-doc /usr/bin/protoc-gen-doc \
    && rm protoc-gen-doc.tar.gz

# Setup directories for the volumes that should be used
WORKDIR /defs

ENTRYPOINT ["protoc"]
