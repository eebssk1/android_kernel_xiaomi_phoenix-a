#!/bin/sh

sudo apt-get install -y libelf-dev libssl-dev dwarves bc jitterentropy-rngd schedtool device-tree-compiler curl

curl -L "https://snapshots.linaro.org/gnu-toolchain/11.2-2021.12-1/aarch64-linux-gnu/gcc-linaro-11.2.1-2021.12-x86_64_aarch64-linux-gnu.tar.xz" | tar -xf - --xz
curl -L "https://snapshots.linaro.org/gnu-toolchain/11.2-2021.12-1/arm-linux-gnueabihf/gcc-linaro-11.2.1-2021.12-x86_64_arm-linux-gnueabihf.tar.xz" | tar -xf - --xz

export PATH=${PWD}/gcc-linaro-11.2.1-2021.12-x86_64_aarch64-linux-gnu/bin:${PWD}/gcc-linaro-11.2.1-2021.12-x86_64_arm-linux-gnueabihf/bin:$PATH

mkdir out

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabihf-

export XXYH="-fgcse-las -fipa-pta -fira-region=all -flimit-function-alignment -floop-nest-optimize -fschedule-insns -fsched-pressure -fsched-spec-load -fsched-stalled-insns=4 -fsched2-use-superblocks -ftree-lrs --param=predictable-branch-outcome=5 --param=max-crossjump-edges=160 --param=max-delay-slot-insn-search=132 --param=max-gcse-insertion-ratio=22 --param=max-pending-list-length=36 --param=max-inline-insns-auto=40 --param=inline-heuristics-hint-percent=672 --param=inline-min-speedup=12 --param=large-function-growth=112 --param=inline-unit-growth=46 --param=ipa-cp-unit-growth=14 --param=max-inline-insns-recursive=500 --param=max-inline-insns-recursive-auto=500 --param=max-inline-recursive-depth-auto=9 --param=max-inline-recursive-depth=9 --param=gcse-cost-distance-ratio=12 --param=max-hoist-depth=45 --param=max-tail-merge-comparisons=11 --param=max-tail-merge-iterations=3 --param=max-stores-to-merge=80 --param=avg-loop-niter=12 --param=dse-max-alias-queries-per-store=274 --param=dse-max-object-size=274 --param=max-reload-search-insns=132 --param=max-sched-ready-insns=160"
export KCFLAGS="-fgraphite -fgraphite-identity $XXYH"

make vendor/phoenix2_defconfig O=out
schedtool -B -e make -j3 O=out
schedtool -B -e make qcom/phoenix-sdmmagpie.dtb -j3 O=out

cp out/arch/arm64/boot/Image.gz AnyKernel3/zImage
cp out/arch/arm64/boot/dts/qcom/phoenix-sdmmagpie.dtb AnyKernel3/dtb
cp out/arch/arm64/boot/dtbo.img AnyKernel3/dtbo.img
