# Dotfiles

## Overview
In this repo you have available my dotfiles for configuration of Hyprland and Waybar

## Listing Content

 - **.zprofile** - Start Hyprland on tty1 after login using 1 of two script[^1]:
    - **hyp** - Start Hyprland with configuration for hybrid and integrated mode
    - **hyp-nvidia** - Start Hyprland with configuration for dGPU Mode(NVIDIA[^2])
 - **hyp** - Hyprland and Hyprpaper[^3] config folder (you need some [dependencies](#Dependencies))
 - **waybar** - waybar config folder

## Dependencies[^4]
 - hyprland-nvidia-git
 - waybar-hyprland-git
 - xdg-desktop-portal-hyprland-git
 - hyprpaper-git[^3]
 - swayidle-git
 - ~~swaylock-effects-git~~[^5]
 - gtlock & modules [^6]
 - grim
 - wdisplays

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

[^1]: Both script need to be in $HOME/.local/bin and .zprofile in the $HOME directory (only works with zsh sheel):

[^2]: For using Hyprland with NVIDIA (desktop GPU or Mobile GPU) you need to patch wlroots manually (or in arch base distro install this [aur](https://aur.archlinux.org/packages/hyprland-nvidia-git) package) and install the appropriate Nvidia drivers (nvidia-dkms) see this [link](https://wiki.hyprland.org/Nvidia/) for more 
information.

[^3]: You need to hypr/hyprpaper.conf and hypr/hyprpaper-nvidia.conf for the path of the photo you whant to use both in preload and wallpaper section ([documentation](https://github.com/hyprwm/hyprpaper))

[^4]: Arch and AUR package you need to shearch for other distro or compile from source

[^5]: ~~you can use [gtklock and respective modules](https://aur.archlinux.org/packages?O=0&SeB=nd&K=gtklock&outdated=&SB=p&SO=d&PP=50&submit=Go) but need to change hypr/set-displays-swayidle.sh script on the swayidle command~~

[^6]: https://aur.archlinux.org/packages?O=0&SeB=nd&K=gtklock&outdated=&SB=p&SO=d&PP=50&submit=Go

[^7]: [Hyprland wiki page](https://wiki.hyprland.org/Useful-Utilities/Screen-Sharing/) about Screen Sharing section [Screensharing](https://gist.github.com/PowerBall253/2dea6ddf6974ba4e5d26c3139ffb7580)
