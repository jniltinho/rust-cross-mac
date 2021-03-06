#!/bin/bash

# docker run -it --rm -v $(pwd):/opt/build -w/opt/build rust:slim-bullseye bash compile-bin.sh

FOLDER=$(pwd)/files
FOLDER_BIN=$(pwd)/files/bin
mkdir -p $FOLDER_BIN

export MACOSX_CROSS_COMPILER=/opt
export PATH=$PATH:/opt/osxcross/target/bin:$FOLDER_BIN

# Install build tools
apt-get update -qq
apt-get install -yqq llvm-dev libclang-dev clang libxml2-dev git curl libz-dev zlib1g-dev libssl-dev make cmake unzip xz-utils

cd $MACOSX_CROSS_COMPILER
git clone https://github.com/tpoechtrager/osxcross
cd osxcross
curl -skL https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX10.13.sdk.tar.xz -o tarballs/MacOSX10.13.sdk.tar.xz
UNATTENDED=1 OSX_VERSION_MIN=10.7 ./build.sh
find . -maxdepth 1 -type f -delete; rm -rf .git tarballs

cd /root
curl -skLO https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz
tar -xf upx-3.9*-amd64_linux.tar.xz; cp upx-3.9*-amd64_linux/upx $FOLDER_BIN/
chmod +x $FOLDER_BIN/upx

curl -skLO https://github.com/cli/cli/releases/download/v2.9.0/gh_2.9.0_linux_amd64.tar.gz
tar -xf gh_*_linux_amd64.tar.gz; mv gh_*_linux_amd64/bin/gh $FOLDER_BIN/

curl -skLO https://github.com/zyedidia/micro/releases/download/v2.0.10/micro-2.0.10-linux64-static.tar.gz
tar -xf micro-*-linux64-static.tar.gz; mv micro-*/micro $FOLDER_BIN/

cargo install --git https://github.com/jniltinho/retry-cli.git
cargo install --git https://github.com/jniltinho/retry-cmd.git
cp /usr/local/cargo/bin/{retry-cli,retry-cmd} $FOLDER_BIN/
chmod +x $FOLDER_BIN/*
upx --best --lzma $FOLDER_BIN/*

cp -aR /opt/osxcross $FOLDER/
cd $FOLDER ; tar -czf compile-bin.tar.gz osxcross bin ; rm -rf osxcross bin
