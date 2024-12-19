#!/bin/sh

sudo apt-get update
sudo apt-get install -y libelf-dev libssl-dev dwarves bc jitterentropy-rngd device-tree-compiler curl libfl2 flex bison

curl -L "https://github.com/eebssk1/aio_tc_build/releases/download/e42fe14d/aarch64-linux-musl-cross.tb2" | tar --bz -xf -
curl -L "https://github.com/eebssk1/aio_tc_build/releases/download/e42fe14d/arm-linux-musleabihf-cross.tb2" | tar --bz -xf -
export PATH=${PWD}/aarch64-linux-musl/bin:${PWD}/arm-linux-musleabihf/bin:$PATH

mkdir out

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-musl-
export CROSS_COMPILE_ARM32=arm-linux-musleabihf-

export KCFLAGS="-fipa-pta"

make vendor/phoenix_defconfig O=out
make -j3 O=out
make qcom/phoenix-sdmmagpie.dtb -j3 O=out

cp out/arch/arm64/boot/Image.gz AnyKernel3/zImage
cp out/arch/arm64/boot/dts/qcom/phoenix-sdmmagpie.dtb AnyKernel3/dtb
cp out/arch/arm64/boot/dtbo.img AnyKernel3/dtbo.img

if [ ! -e out/arch/arm64/boot/Image.gz ]
then
exit 1
fi
