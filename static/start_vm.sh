#!/bin/bash
set -x

# 1. Stop the KDE display manager
systemctl stop sddm.service
sleep 3

# 2. Forcefully kill any lingering Wayland compositors holding the DRM node
killall kwin_wayland
sleep 2

# 3. Unbind the hidden text consoles (TTYs)
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind
sleep 1

# 4. Unbind the EFI Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
sleep 2

# 5. Unload the AMD graphics and audio drivers
modprobe -r amdgpu
modprobe -r snd_hda_intel
sleep 2

# 6. Load the VFIO holding drivers
modprobe vfio-pci
sleep 2
