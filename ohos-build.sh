#!/bin/bash
set -Eeuo pipefail

OLD_PATH=$PATH

trap "export PATH=${OLD_PATH}; unset CC CXX AS LD LDXX LLD STRIP RANLIB OBJDUMP OBJCOPY READELF NM AR PROFDATA CFLAGS CXXFLAGS LDFLAGS LDSHARED" ERR SIGINT SIGTERM

if [ -z "${OHOS_SDK}" ]; then
	echo "[TIPS] please set OHOS_SDK env first"
	exit 0
fi

CMAKE_BIN=${OHOS_SDK}/native/build-tools/cmake/bin/cmake
CMAKE_TOOLCHAIN_CONFIG=${OHOS_SDK}/native/build/cmake/ohos.toolchain.cmake

# OHOS_CPU=aarch64
# OHOS_ARCH=arm64-v8a
# OHOS_CPU=arm
# OHOS_ARCH=armeabi-v7a
OHOS_CPU=x86_64
OHOS_ARCH=x86_64


export CC="${OHOS_SDK}/native/llvm/bin/clang --target=${OHOS_CPU}-linux-ohos"
export CXX="${OHOS_SDK}/native/llvm/bin/clang++ --target=${OHOS_CPU}-linux-ohos"
export AS=${OHOS_SDK}/native/llvm/bin/llvm-as
export LD=${OHOS_SDK}/native/llvm/bin/ld.lld
export LDXX=${LD}
export LLD=${LD}
export STRIP=${OHOS_SDK}/native/llvm/bin/llvm-strip
export RANLIB=${OHOS_SDK}/native/llvm/bin/llvm-ranlib
export OBJDUMP=${OHOS_SDK}/native/llvm/bin/llvm-objdump
export OBJCOPY=${OHOS_SDK}/native/llvm/bin/llvm-objcopy
export READELF=${OHOS_SDK}/native/llvm/bin/llvm-readelf
export NM=${OHOS_SDK}/native/llvm/bin/llvm-nm
export AR=${OHOS_SDK}/native/llvm/bin/llvm-ar
export PROFDATA=${OHOS_SDK}/native/llvm/bin/llvm-profdata
export CFLAGS="-fPIC -D__MUSL__=1"
export CXXFLAGS="-fPIC -D__MUSL__=1"
export LDFLAGS="-fuse-ld=lld"
export LDSHARED=${CC}

export PATH=${OHOS_SDK}/native/llvm/bin:${OHOS_SDK}/native/toolchains:$PATH

${CMAKE_BIN} -DOHOS_STL=c++_shared -DOHOS_ARCH=${OHOS_ARCH} -DOHOS_PLATFORM=OHOS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_CONFIG} -B build

${CMAKE_BIN} --build build

# restore old $PATH value
export PATH=$OLD_PATH
unset CC CXX AS LD LDXX LLD STRIP RANLIB OBJDUMP OBJCOPY READELF NM AR PROFDATA CFLAGS CXXFLAGS LDFLAGS LDSHARED
