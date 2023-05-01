# Dotfiles

## Overview
In this repo you have available my dotfiles for configuration of Hyprland and Waybar and configuration for my gentoo system

## Listing Content

 - **.zprofile** - Start Hyprland on tty1 after login using 1 of two script:
    - **hyp** - Start Hyprland with configuration for hybrid and integrated mode
    - **hyp-nvidia** - Start Hyprland with configuration for NVIDIA dGPU Mode
 - **hyp** - Hyprland and Hyprpaper config folder
 - **waybar** - waybar config folder
 - **rofi** - rofi config folder
 - **sway** - my old sway config (depecrated and not in use)
 - **networkmanager-dmenu** - networkmanager-dmenu config (compatible with rofi as well)
 - **etc** - etc folder with portage (gentoo) config and other config to my system [more in the future...]

## Notes

For Fix Recording on OBS add this enviroment LIBVA_DRIVER_NAME on the hyp and hyp-nvidia (you can use my settings if you have AMD+NVIDIA Laptop):
- For AMD+NVIDIA: LIBVA_DRIVER_NAME="radeonsi;vdpau;nvidia"
- For NVIDIA dGPU MODE: LIBVA_DRIVER_NAME="vdpau;nvidia"
- For AMD iGPU & dGPU: export LIBVA_DRIVER_NAME="radeonsi"
- For Intel+Nvidia:
   - libva-intel-driver: LIBVA_DRIVER_NAME="i965;vdpau;nvidia"
   - intel-media-driver: LIBVA_DRIVER_NAME="iHD;vdpau;nvidia"
- For Intel+AMD*:
   - libva-intel-driver: LIBVA_DRIVER_NAME="i965;radeonsi"
   - intel-media-driver: LIBVA_DRIVER_NAME="iHD;radeonsi"

*very strange configuration but exist

Fixing app recording on obs or screensharing in the browser you need to install xdg-desktop-portal-hyprland-git and add this line to the hyprland.conf [^7]:

```
hypr/hyprland.conf
------------
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
```
