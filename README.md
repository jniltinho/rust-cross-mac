## A docker image for rust cross compiling for Windows/macOS.

## Howtos

```
## Docker
## docker run -it --rm -v $(pwd):/opt/project -w/opt/project ghcr.io/jniltinho/rust-cross-mac bash

# make sure you have a proper C/C++ native compiler first, as a suggestion:
apt-get update
apt-get install -y llvm-dev libclang-dev clang libxml2-dev zlib1g-dev libssl-dev build-essential
apt-get install -y gcc g++ libmpc-dev libmpfr-dev libgmp-dev make cmake git lzma-dev patch gcc-mingw-w64-x86-64

# change the following path to match your setup
export MACOSX_CROSS_COMPILER=/opt

cd $MACOSX_CROSS_COMPILER
git clone https://github.com/tpoechtrager/osxcross
cd osxcross
curl -skL https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX10.13.sdk.tar.xz -o tarballs/MacOSX10.13.sdk.tar.xz
UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh
find . -maxdepth 1 -type f -delete; rm -rf .git tarballs

cd /root
echo '[target.x86_64-apple-darwin]
linker = "x86_64-apple-darwin17-clang"
ar = "x86_64-apple-darwin17-ar"' > $MACOSX_CROSS_COMPILER/osxcross/cargo_config
echo >> $MACOSX_CROSS_COMPILER/osxcross/cargo_config

cat $MACOSX_CROSS_COMPILER/osxcross/cargo_config

echo '#!/usr/bin/env bash
MACOS_TARGET="x86_64-apple-darwin"
export PATH="$PATH:/opt/osxcross/target/bin"
export LIBZ_SYS_STATIC=1
export CC=o64-clang
export CXX=o64-clang++

cargo build --release --target "${MACOS_TARGET}"' > /usr/local/bin/build-mac-release
chmod +x /usr/local/bin/build-mac-release

echo 'export PATH="$PATH:/opt/osxcross/target/bin"' >> $HOME/.profile
source $HOME/.profile

## Add support Compile Windows/Mac
rustup target add x86_64-pc-windows-gnu
rustup target add x86_64-apple-darwin
rustup target add x86_64-unknown-linux-musl

cd $HOME
cargo new hello_cargo
cd hello_cargo
mkdir -p .cargo ; cp $MACOSX_CROSS_COMPILER/osxcross/cargo_config .cargo/config
cargo build --release --target x86_64-apple-darwin
cargo build --release --target x86_64-pc-windows-gnu
cargo build --release --target x86_64-unknown-linux-musl
cargo build --release
```


## Links

- https://wapl.es/rust/2019/02/17/rust-cross-compile-linux-to-macos.html
- https://godot-rust.github.io/book/exporting/macosx.html
- https://github.com/phracker/MacOSX-SDKs/releases
- https://github.com/autozimu/docker-rust-cross-for-macos
- https://stackoverflow.com/questions/31492799/cross-compile-a-rust-application-from-linux-to-windows
- https://github.com/cross-rs/cross
- https://github.com/KodrAus/rust-cross-compile
- https://github.com/multiarch/crossbuild
- https://github.com/tpoechtrager/osxcross#installation
- https://apt.llvm.org/
- https://launchpad.net/ubuntu/+source/llvm-toolchain-13
