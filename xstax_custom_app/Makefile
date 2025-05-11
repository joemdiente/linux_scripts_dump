#
# Build example.c using mscc toolchain
#

# For 2024.12 brsdk
TOOLCHAIN_GCC_ARM64_PATH:=/opt/mscc/mscc-toolchain-bin-2024.02.6-108/arm64-armv8_a-linux-gnu/bin/aarch64-armv8_a-linux-gnu-
TOOLCHAIN_GCC_ARM_PATH:=/opt/mscc/mscc-toolchain-bin-2024.02.6-108/arm-cortex_a8-linux-gnueabihf/bin/arm-cortex_a8-linux-gnueabihf-
TOOLCHAIN_GCC_MIPSGNU_PATH:=/opt/mscc/mscc-toolchain-bin-2024.02.6-108/mipsel-mips32r2-linux-gnu/bin/mipsel-mips32r2-linux-gnu-
TOOLCHAIN_GCC_MIPSUC_PATH:=/opt/mscc/mscc-toolchain-bin-2024.02.6-108/mipsel-mips32r2-linux-uclibc/bin/mipsel-mips32r2-linux-uclibc-

arm64:
	make compile TOOLCHAIN_CURRENT_PATH=${TOOLCHAIN_GCC_ARM64_PATH}
arm:
	make compile TOOLCHAIN_CURRENT_PATH=${TOOLCHAIN_GCC_ARM_PATH}
	
mips_uc:
	make compile TOOLCHAIN_CURRENT_PATH=${TOOLCHAIN_GCC_MIPSUC_PATH}

mips_gnu:
	make compile TOOLCHAIN_CURRENT_PATH=${TOOLCHAIN_GCC_MIPSGNU_PATH}
	make compile
native:
	gcc example.c -o example_native

run_native: 
	./example_native

compile:
	${TOOLCHAIN_CURRENT_PATH}gcc example.c -o ./fsoverlay/usr/bin/example

transfer:
	sudo rsync -avrP ./fsoverlay/usr/bin/example /srv/tftp