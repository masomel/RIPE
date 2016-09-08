# Makefile for RIPE
# @author John Wilander & Nick Nikiforakis
# UTILS := $(COMP_BENCH)/src/util/icc_wrappers/__intel_new_feature_proc_init.c $(UTILS)
CLANG_SOFTBOUND_PATH := ${BIN_PATH}/softboundcets/build/llvm/Release+Asserts/bin
SOFTBOUND_RUNTIME_PATH := ${BIN_PATH}/softboundcets/src/softboundcets-lib/
GOLD_PATH := ${BIN_PATH}/binutils_gold/install
CLANG_SAFECODE_PATH := ${GOLD_PATH}/bin/

# Default:
# disable some protection mechanisms
CFLAGS := -fno-stack-protector -Wl,-z,execstack -ggdb

all: gcc

# ==================
# Native compilation
# ==================
gcc: CC := gcc
gcc: CFLAGS += -Wno-int-conversion -Wno-incompatible-pointer-types -m32
gcc: CFLAGS += -B /root/bin/gcc/install/lib/gcc/x86_64-pc-linux-gnu/6.1.0/32/ -B /root/bin/gcc/install/lib32/
gcc: export LIBRARY_PATH := /usr/lib32:$(LIBRARY_PATH)
gcc: ripe_attack_generator

gcc_64: CC := gcc
gcc_64: CFLAGS += -Wno-int-conversion -Wno-incompatible-pointer-types
gcc_64: ripe_attack_generator_64

icc: CC := icc
icc: CFLAGS += -wd144,556,167
icc: ripe_attack_generator

icc_64: CC := icc
icc_64: CFLAGS += -wd144,556,167
# icc_64: CFLAGS += -wd144,556
icc_64: ripe_attack_generator_64


clang_64: CC := $(CLANG_SOFTBOUND_PATH)/clang
clang_64: CFLAGS += -Wno-int-conversion -Wno-incompatible-pointer-types -Wno-format
clang_64: CFLAGS += -flto -fno-vectorize # with version 3.4.0 use -fno-vectorize
clang_64: ripe_attack_generator_64

clang_safe_64: CC := $(CLANG_SAFECODE_PATH)/clang
clang_safe_64: CFLAGS += -Wno-int-conversion -Wno-incompatible-pointer-types -Wno-format
clang_safe_64: ripe_attack_generator_64

# ==================
# MPX
# ==================
gcc_mpx: CFLAGS += -fcheck-pointer-bounds -mmpx -static-libmpx -static-libmpxwrappers
gcc_mpx: gcc

gcc_64_mpx: CFLAGS += -fcheck-pointer-bounds -mmpx -static-libmpx -static-libmpxwrappers
gcc_64_mpx: gcc_64

icc_mpx: CFLAGS += -check-pointers-mpx=rw -lmpx -I/root/bin/gcc/build/gcc/include/
icc_mpx: icc

icc_64_mpx: CFLAGS += -check-pointers-mpx=rw -lmpx -I/root/bin/gcc/build/gcc/include/
icc_64_mpx: icc_64

# ==================
# ASan
# ==================
gcc_asan: CFLAGS += -fsanitize=address
gcc_asan: export LD_LIBRARY_PATH=/root/bin/gcc/build/x86_64-pc-linux-gnu/32/libsanitizer/asan/.libs/:$(LD_LIBRARY_PATH)
# gcc_asan: CFALGS += /root/bin/gcc/build/x86_64-pc-linux-gnu/32/libsanitizer/asan/.libs/
gcc_asan: gcc

gcc_64_asan: CFLAGS += -fsanitize=address
gcc_64_asan: gcc_64

# ==================
# SoftBound - only 64
# ==================
clang_64_softbound: CFLAGS += -fsoftboundcets
clang_64_softbound: CFLAGS += -L $(SOFTBOUND_RUNTIME_PATH)
clang_64_softbound: CFLAGS += -lm -lrt
clang_64_softbound: clang_64


# clang_safe_64_enabled: CFLAGS += -bbc
clang_safe_64_enabled: CFLAGS += -fmemsafety -g -L /root/bin/binutils_gold/install/lib/ -fmemsafety-terminate -stack-protector=1
clang_safe_64_enabled: clang_safe_64


# ATTACK GENERATOR COMPILE
ripe_attack_generator: ./source/ripe_attack_generator.c
	$(CC) $(CFLAGS) ./source/ripe_attack_generator.c -m32 $(UTILS) -o ./build/ripe_attack_generator

ripe_attack_generator_64: ./source/ripe_attack_generator.c
	$(CC) $(CFLAGS) ./source/ripe_attack_generator_64.c $(UTILS) -o ./build/ripe_attack_generator

clean:
	rm ./build/*

