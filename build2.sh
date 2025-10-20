#!/bin/bash
echo "Cloning dependencies"

if [ ! -d "clang" ]; then
    git clone --depth=1 https://github.com/crdroidandroid/android_prebuilts_clang_host_linux-x86_clang-5484270 -b 9.0 clang
else
    echo "clang already exists, skipping clone."
fi

if [ ! -d "gcc" ]; then
    git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 gcc
else
    echo "gcc already exists, skipping clone."
fi

if [ ! -d "gcc32" ]; then
    git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 gcc32
else
    echo "gcc32 already exists, skipping clone."
fi

echo "Done"
KERNEL_DIR=$(pwd)
PATH="${KERNEL_DIR}/clang/bin:${KERNEL_DIR}/gcc/bin:${KERNEL_DIR}/gcc32/bin:${PATH}"
export ARCH=arm64

make O=out ARCH=arm64 lancelot_defconfig \

    make -j$(nproc) O=out \
                    ARCH=arm64 \
                    CC=clang \
                    CLANG_TRIPLE=aarch64-linux-gnu- \
                    CROSS_COMPILE=aarch64-linux-android- \
                    CROSS_COMPILE_ARM32=arm-linux-androideabi- $1 $2 $3

exit
