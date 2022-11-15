#!/usr/bin/env bash

DIR=$(
  cd "$(dirname "$0")"
  pwd
)
set -ex
cd $DIR

export API=30
export NDK_VERSION=24.0.8215888

export TARGET=aarch64-linux-android
ABI=$TARGET
RUST_TARGET=$TARGET

# export TARGET=armv7a-linux-androideabi
# ABI=arm-linux-androideabi
# RUST_TARGET=armv7-linux-androideabi

export os=$(uname -s | awk '{ print tolower($0) }')
export NDK=$HOME/Library/Android/sdk/ndk/$NDK_VERSION
export ANDROID_NDK_HOME=$NDK
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$os-x86_64
export PATH=$TOOLCHAIN/bin:$PATH
export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/$TARGET-ld
export RANLIB=$TOOLCHAIN/bin/$ABI-ranlib
export STRIP=$TOOLCHAIN/bin/$ABI-strip

CARGO_TARGET=$(echo ${TARGET//-/_} | awk '{ print toupper($0) }')
export CARGO_TARGET_${CARGO_TARGET}_LINKER=$CC

echo 'AR = '$AR
echo 'AS = '$AS
echo 'CC = '$CC
echo 'CXX = '$CXX
echo 'LD = '$LD
echo 'RANLIB = '$RANLIB
echo 'STRIP = '$STRIP

RUSTFLAGS="-C target-feature=+crt-static" \
  RUST_BACKTRACE=1 \
  cargo +nightly build \
  --release --target $RUST_TARGET

ls -alh ./target/$RUST_TARGET/release
