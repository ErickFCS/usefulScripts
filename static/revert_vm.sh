#!/bin/bash
set -x

# 1. Unload the VFIO holding drivers
modprobe -r vfio-pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# 2. Reload the AMD drivers
modprobe amdgpu
modprobe snd_hda_intel

# 3. Rebind the EFI Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

# 4. Rebind the text consoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

# 5. Restart the KDE display manager
systemctl start sddm.service
