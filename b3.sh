#!/bin/sh

sudo apt-get install -y libelf-dev libssl-dev dwarves bc jitterentropy-rngd schedtool device-tree-compiler curl

curl -L "https://developer.arm.com/-/media/Files/downloads/gnu/11.2-2022.02/binrel/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu.tar.xz" | tar -xf - --xz
curl -L "https://developer.arm.com/-/media/Files/downloads/gnu/11.2-2022.02/binrel/gcc-arm-11.2-2022.02-x86_64-arm-none-linux-gnueabihf.tar.xz" | tar -xf - --xz

export PATH=${PWD}/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/bin:${PWD}/gcc-arm-11.2-2022.02-x86_64-arm-none-linux-gnueabihf/bin:$PATH

mkdir out

export ARCH=arm64
export CROSS_COMPILE=aarch64-none-linux-gnu-
export CROSS_COMPILE_ARM32=arm-none-linux-gnueabihf-

export XXYH="-fipa-pta -ftree-lrs -fno-align-functions -fno-align-jumps -fno-align-labels -fno-align-loops -floop-nest-optimize -fsched2-use-superblocks -fschedule-insns -fsched-spec-load -fsched-stalled-insns --param predictable-branch-outcome=10 --param max-crossjump-edges=160 --param max-delay-slot-insn-search=132 --param max-gcse-insertion-ratio=22 --param max-pending-list-length=36 --param max-inline-insns-auto=40 --param inline-heuristics-hint-percent=672 --param inline-min-speedup=12 --param large-function-growth=112 --param inline-unit-growth=46 --param ipa-cp-unit-growth=14 --param max-inline-insns-recursive=500 --param max-inline-insns-recursive-auto=500 --param max-inline-recursive-depth-auto=10 --param max-inline-recursive-depth=10 --param gcse-cost-distance-ratio=12 --param max-hoist-depth=50 --param max-tail-merge-comparisons=12 --param max-tail-merge-iterations=4 --param max-stores-to-merge=80 --param avg-loop-niter=8 --param dse-max-alias-queries-per-store=274 --param dse-max-object-size=274 --param max-reload-search-insns=132 --param max-sched-ready-insns=160 --param analyzer-max-recursion-depth=4 --param sched-autopref-queue-depth=2 --param uninit-control-dep-attempts=1280 --param max-slsr-cand-scan=76 --param sched-pressure-algorithm=1 --param gimple-fe-computed-hot-bb-threshold=4 --param unroll-jam-min-percent=5 --param unroll-jam-max-unroll=5 --param inline-heuristics-hint-percent=450 --param ipa-cp-min-recursive-probability=4"
export KCFLAGS="-fgraphite -fgraphite-identity $XXYH"

make vendor/phoenix2_defconfig O=out
schedtool -B -e make -j3 O=out
schedtool -B -e make qcom/phoenix-sdmmagpie.dtb -j3 O=out

cp out/arch/arm64/boot/Image.gz AnyKernel3/zImage
cp out/arch/arm64/boot/dts/qcom/phoenix-sdmmagpie.dtb AnyKernel3/dtb
cp out/arch/arm64/boot/dtbo.img AnyKernel3/dtbo.img
