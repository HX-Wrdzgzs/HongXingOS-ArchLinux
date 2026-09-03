# HongXingOS Linux architecture

## Current definition

HongXingOS 7 Dev Preview is an Arch-derived distribution image, not an independent Linux userspace distribution.

Current boundary:

- Linux kernel, systemd, glibc, Mesa, Plasma and most packages come from Arch Linux upstream repositories.
- HongXingOS owns image composition, distribution identity, default desktop experience, boot branding and future system utilities.
- pacman remains the native package manager.

## Build model

The repository does not vendor a complete archiso profile. `build/build.sh` copies the `baseline` profile installed with the current `archiso` package, then overlays HongXingOS configuration. This reduces maintenance when archiso changes.

## Milestones

### M0 — VMware bring-up

- Bootable BIOS/UEFI ISO
- KDE Plasma
- SDDM autologin
- NetworkManager
- open-vm-tools
- HongXingOS identity
- Plymouth and wallpapers

### M1 — Installable image

- Calamares or equivalent installer
- Btrfs layout
- user/locale/timezone setup
- installed-system bootloader configuration

### M2 — Distribution layer

- HongXingOS package repository
- `hongxingos-base`
- `hongxingos-branding`
- `hongxingos-desktop`
- update/recovery utilities

### M3 — Recovery and platform integration

- snapshot/rollback workflow
- recovery environment
- AuthLit integration only where it provides a concrete system function
