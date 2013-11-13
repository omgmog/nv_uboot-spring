#!/bin/sh

# In this example will use the daisy board and snow device tree
BOARD=daisy_spring
FDT=spring

cros_workon --board=${BOARD} start chromeos-u-boot

# Get the fixup to load U-Boot at an alternate address
pushd ~/trunk/src/third_party/u-boot/files

repo start altAddr .
git fetch \
http://chromium.googlesource.com/chromiumos/third_party/u-boot \
  refs/changes/49/39649/1 && git cherry-pick FETCH_HEAD

# Add the hub power up patch for Spring
# https://chromium-review.googlesource.com/#/c/65542/

git fetch \
https://chromium.googlesource.com/chromiumos/third_party/u-boot \
  refs/changes/42/65542/1 && git cherry-pick FETCH_HEAD

# If you want to apply the two patches for simplefb and simplified
# environment, then also do these two (commented-out) cherry-picks:

# git fetch \
#   https://chromium.googlesource.com/chromiumos/third_party/u-boot \
#   refs/changes/58/49358/2 && git cherry-pick FETCH_HEAD

# git fetch \
#   https://chromium.googlesource.com/chromiumos/third_party/u-boot \
#   refs/changes/48/50848/1 && git cherry-pick FETCH_HEAD


# Build things now that we've patched it up
USE='spring' emerge-${BOARD} chromeos-ec chromeos-u-boot chromeos-bootimage

# Don't leave the altAddr hack there
git checkout m/master
popd

# Produce U_BOOT file and find the text_start
dump_fmap -x /build/${BOARD}/firmware/nv_image-${FDT}.bin U_BOOT
TEXT_START=$(awk '$NF == "__text_start" { printf "0x"$1 }' \
 /build/${BOARD}/firmware/System.map)

# Make it look like an image U-Boot will like:
# The "-a" and "-e" here are the "CONFIG_SYS_TEXT_BASE" from
# include/configs/exynos5-common.h
sudo mkimage \
 -A arm \
 -O linux \
 -T kernel \
 -C none \
 -a "${TEXT_START}" -e "${TEXT_START}" \
 -n "Non-verified u-boot" \
 -d U_BOOT /build/${BOARD}/firmware/nv_uboot-${FDT}.uimage

MY_BINARY=/build/${BOARD}/firmware/nv_uboot-${FDT}.uimage

# Sign the uimage
echo blah > dummy.txt
sudo vbutil_kernel \
 --pack /build/${BOARD}/firmware/nv_uboot-${FDT}.kpart \
  --keyblock /usr/share/vboot/devkeys/kernel.keyblock \
  --signprivate /usr/share/vboot/devkeys/kernel_data_key.vbprivk \
  --version 1 \
  --vmlinuz ${MY_BINARY} \
  --bootloader dummy.txt \
  --config dummy.txt \
  --arch arm

KPART=/build/${BOARD}/firmware/nv_uboot-${FDT}.kpart

