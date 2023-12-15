MSCC_OPT := /opt/mscc

MSCC_TOOLCHAIN_DIR := m/opt/mscc/mscc-toolchain-bin-2023.02-101/mipsel-mips32r2-linux-gnu
MSCC_TARGET_ARCH := mipsel-mips32r2-linux-gnu
native:
	gcc -g helloworld.c -o helloworld
vsc_toolchain:
	$(MSCC_OPT)/$(MSCC_TOOLCHAIN_DIR)/$(MSCC_TARGET_ARCH)/bin/mipsel-linux-gcc -g helloworld.c -o helloworld_vsc
tftp:
	sudo cp helloworld* /srv/tftp
all:
	native vsc_toolchain debug