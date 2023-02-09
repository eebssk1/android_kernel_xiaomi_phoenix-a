#!/bin/sh

sudo apt-get install -y libelf-dev libssl-dev dwarves bc jitterentropy-rngd device-tree-compiler curl python2

curl -L "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz?rev=6750d007ffbf4134b30ea58ea5bf5223&hash=6C7D2A7C9BD409C42077F203DF120385AEEBB3F5" | tar -xf - --xz
curl -L "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz?rev=9929cb6c0e8948f0ba1a621167fcd56d&hash=1259035C716B41C675DCA7D76913684B5AD8C239" | tar -xf - --xz

export PATH=${PWD}/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu/bin:${PWD}/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-linux-gnueabihf/bin:$PATH

mkdir out

export ARCH=arm64
export CROSS_COMPILE=aarch64-none-linux-gnu-
export CROSS_COMPILE_ARM32=arm-none-linux-gnueabihf-

export XXYH="-fipa-pta -flimit-function-alignment -fsched-spec-load -fsched-stalled-insns=2 -fsched-stalled-insns-dep=3 -fira-loop-pressure -floop-nest-optimize --param=predictable-branch-outcome=4 --param=max-crossjump-edges=300 --param=max-delay-slot-insn-search=325 --param=inline-heuristics-hint-percent=615 --param=inline-min-speedup=35 --param=max-inline-recursive-depth-auto=10 --param=max-inline-recursive-depth=12 --param=min-inline-recursive-probability=12 --param=modref-max-adjustments=15 --param=modref-max-depth=325 --param=min-vect-loop-bound=2 --param=gcse-cost-distance-ratio=13 --param=gcse-unrestricted-cost=2 --param=max-hoist-depth=90 --param=avg-loop-niter=10 --param=dse-max-object-size=368 --param=dse-max-alias-queries-per-store=320 --param=scev-max-expr-size=128 --param=scev-max-expr-complexity=12 --param=max-predicted-iterations=154 --param=max-reload-search-insns=185 --param=max-cselib-memory-locations=600 --param=max-sched-ready-insns=190 --param=sched-autopref-queue-depth=3 --param=analyzer-max-recursion-depth=5 --param=gimple-fe-computed-hot-bb-threshold=3 --param=max-cse-path-length=16 --param=max-rtl-if-conversion-insns=20 --param=max-sched-extend-regions-iters=4 --param=max-stores-to-sink=4 --param=ranger-logical-depth=14 --param=vect-partial-vector-usage=1 --param=analyzer-bb-explosion-factor=6 --param=analyzer-max-enodes-per-program-point=10 --param=hash-table-verification-limit=16 --param=fsm-scale-path-blocks=4 --param=fsm-scale-path-stmts=3 --param=graphite-max-arrays-per-scop=160 --param=sms-max-ii-factor=3 --param=sms-dfa-history=2 --param=sms-loop-average-count-threshold=5 --param=unroll-jam-min-percent=3 --param=max-ssa-name-query-depth=4  --param=max-slsr-cand-scan=120 --param=max-sched-extend-regions-iters=3 --param=scev-max-expr-complexity=16 --param=scev-max-expr-size=128 --param=min-vect-loop-bound=3"
export KCFLAGS="-fgraphite -fgraphite-identity ${XXYH}"

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
