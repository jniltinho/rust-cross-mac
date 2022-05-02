FROM rust:slim-bullseye
ENV TZ America/Sao_Paulo

# docker build --no-cache -t ghcr.io/jniltinho/rust-cross-mac -f Dockerfile .
# docker run -it --rm -v $(pwd):/opt/rust/build ghcr.io/jniltinho/rust-cross-mac bash

RUN rm /bin/sh && ln -s /bin/bash /bin/sh; mkdir -p /opt/rust
RUN sed -i 's|# export LS_OPTIONS|export LS_OPTIONS|' /root/.bashrc; sed -i 's|# alias|alias|' /root/.bashrc; source /root/.bashrc

ENV DEBIAN_FRONTEND noninteractive
ENV MACOSX_CROSS_COMPILER=/opt
ENV PATH $PATH:/opt/osxcross/target/bin

# Install build tools
RUN apt-get update -qq \
    && apt-get install -yqq llvm-dev libclang-dev pkg-config clang libxml2-dev make curl git file libz-dev zlib1g-dev libssl-dev gcc-mingw-w64-x86-64 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb

COPY files/compile-bin.tar.gz /opt/
COPY cargo_config /opt/rust/
COPY build-mac-release.sh /usr/local/bin/build-mac-release

WORKDIR /opt
RUN tar xf compile-bin.tar.gz; mv bin/* /usr/local/bin/ ; rm -rf bin compile-bin.* \ 
    && cargo install cargo-get; rustup component add rustfmt \
    && rm -rf /usr/local/cargo/registry/{cache,src} \
    && chmod +x /usr/local/bin/build-mac-release

WORKDIR /opt/rust
