# How to setup Nvidia Optimus on Linux

This tutorial was made for arch and Gentoo base distros, this can be adapt for any distro open a pull request or a issue indicating the package name

Note: The tool use in this guide were developer for Asus laptop if you are using a Asus laptop please refer to this [link](https://asus-linux.org/) for other brands try this method

My Setup:
- Lenovo Legion 5 15ACH6H running Vanila Arch and Gentoo on two sepreate btrfs subvolume;
- The laptop need to stay in hybrid mode and iGPU set at minium to use 1Gbit of memory in the bios (call * in the bios);
- I also use the Nvidia dGPU as passthouth for a Windows 11 VM for this you need a HDMI (or Mini-DP/DP) dummy plug when you don’t have a external display (optional);

## Install Package

- Gentoo:

&nbsp;Frist you need to add and sync **zGentoo** overlay
```bash
sudo eselect repository enable zGentoo 
sudo emerge --sync -r zGentoo
```

&nbsp;Then you need to install supergfxctl:
```bash
sudo emerge --ask sys-power/supergfxctl
```

- Arch:

&nbsp;You have to opcion install AUR package manually or using a aur helper:

&nbsp;&nbsp;Using and Aur Helper to install the package:
```bash
#Using yay
sudo yay -Sy supergfxctl
```
```bash
#Using paru
sudo paru -Sy supergfxctl
```
&nbsp;&nbsp;Installing the package manually

```bash
git clone https://aur.archlinux.org/supergfxctl.git
cd supergfxctl
makepkg -Si
```

- From source or other distros:
&nbsp;Find the name of the package on your distro or go to this [link](https://gitlab.com/asus-linux/supergfxctl) with instruction how to compile from source

## Configuring supergfxctl

You need to create this file ```/etc/supergfxd.conf```:

```bash
/etc/supergfxd.conf
----------------------
{
"mode": "Integrated", # choose between hybrid, integrated or vfio
"vfio_enable": true, # binds the dGPU to vfio for VM pass-through (optional is set to false by default)
"vfio_save": false, # save the vfio state
"compute_save": false, # only asus laptop
"always_reboot": false, # not necessary to reboot (sometimes changing from hybrid -> integrated -> vfio required a reboot)
"no_logind": true, # set to true if you have a login manager like sddm or lightdm
"logout_timeout_s": 180 #not need to change
}% 
```
After this you only need to enable supergfxd.service and reboot
```bash
sudo systemctl enable supergfxd.service
```
**NOTE: DONT FORGET TO CHANGE GRAPHIC MODE TO HYBRID IN THE BIOS**

## Set Integrated or Hybrid mode at boot time (optional)

This is made using a kernel parameter:
- Grub:

```bash
/etc/default/grub
----------------------
# For the IGPU
...
GRUB_CMDLINE_LINUX_DEFAULT="... supergfxd.mode=integrated"
#For Hybrid
GRUB_CMDLINE_LINUX_DEFAULT="... supergfxd.mode=hybrid"
...
```

Then you just need to update Grub:
```bash
sudo update-grub
```

- Dracut:

```bash
/etc/dracut.conf.d/cmdline.conf or /etc/dracut.conf
----------------------
# For the IGPU
...
kernel_cmdline="... supergfxd.mode=integrated"
#For Hybrid
kernel_cmdline="... supergfxd.mode=hybrid"
...
```

Then you just need to update dracut:
```bash
#Gentoo
sudo emerge --config sys-kernel/gentoo-kernel-bin
#Arch
doas dracut --regenerate-all --force --uefi
```

## Using dGPU

In the [supergfxctl repo](https://gitlab.com/asus-linux/supergfxctl) we have this statement:

"ASUS G-Sync + ASUS GPU-MUX note: Some ASUS laptops are capable of using the dGPU as the sole GPU in the system which is generally to enable g-sync on the laptop display panel. This is controlled by asusctl at this time, and may be added to supergfxd later. If mux/g-sync is enabled then supergfxd will halt itself until it is disabled again."

This mean on non Asus laptop for now you have to option:
- Disable supergfxd.service and change to dGPU:
```bash
sudo systemctl disable supergfxd.service
```
- Uninstall the package

## Obligatory don't take me to court

- no warranty, use this tutorial at you own risk

