#!/bin/sh

git clone --depth 1 https://github.com/kdrag0n/proton-clang

sudo apt-get install -y libelf-dev libssl-dev dwarves bc jitterentropy-rngd schedtool device-tree-compiler

export PATH=${PWD}/proton-clang/bin:$PATH

mkdir out

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

make vendor/phoenix_defconfig CC=clang LD=ld.lld NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out
schedtool -B -e make -j3 CC=clang LD=ld.lld NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip O=out
schedtool -B -e make qcom/phoenix-sdmmagpie.dtb -j3 CC=clang LD=ld.lld NM=llvm-nm OBJCOPY=llvm-objcopy O=out

cp out/arch/arm64/boot/Image.gz AnyKernel3/zImage
cp out/arch/arm64/boot/dts/qcom/phoenix-sdmmagpie.dtb AnyKernel3/dtb
cp out/arch/arm64/boot/dtbo.img AnyKernel3/dtbo.img
