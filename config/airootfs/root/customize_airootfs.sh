#!/usr/bin/env bash
set -euo pipefail

sed -i 's/^#zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc || true

echo 'hongxingos' > /etc/hostname

cat > /usr/lib/os-release <<'OSRELEASE'
NAME="HongXingOS"
PRETTY_NAME="HongXingOS 7 Dev Preview"
ID=hongxingos
ID_LIKE=arch
VERSION_ID="7-dev"
BUILD_ID=rolling
ANSI_COLOR="38;2;255;45;20"
HOME_URL="https://github.com/HX-Wrdzgzs/HongXingOS-ArchLinux"
DOCUMENTATION_URL="https://github.com/HX-Wrdzgzs/HongXingOS-ArchLinux"
SUPPORT_URL="https://github.com/HX-Wrdzgzs/HongXingOS-ArchLinux/issues"
BUG_REPORT_URL="https://github.com/HX-Wrdzgzs/HongXingOS-ArchLinux/issues"
LOGO=hongxingos
OSRELEASE
ln -sfn ../usr/lib/os-release /etc/os-release

cat > /etc/issue <<'ISSUE'
HongXingOS 7 Dev Preview \r (\l)
ISSUE

cat > /etc/motd <<'MOTD'
HongXingOS 7 Dev Preview
Arch-derived development image
MOTD

if ! id liveuser >/dev/null 2>&1; then
  useradd -m -G wheel -s /bin/bash liveuser
fi
printf 'liveuser:hongxing\n' | chpasswd

install -d -m 0755 /etc/sudoers.d
cat > /etc/sudoers.d/10-liveuser <<'SUDOERS'
liveuser ALL=(ALL:ALL) NOPASSWD: ALL
SUDOERS
chmod 0440 /etc/sudoers.d/10-liveuser

systemctl enable NetworkManager.service
systemctl enable sddm.service
systemctl set-default graphical.target
systemctl enable vmtoolsd.service
systemctl enable vmware-vmblock-fuse.service 2>/dev/null || true

if command -v plymouth-set-default-theme >/dev/null 2>&1; then
  plymouth-set-default-theme hongxingos
fi

chmod 0755 /usr/local/bin/hongxingos-set-wallpaper
chmod 0755 /usr/local/bin/hxdiag

if [[ -d /home/liveuser ]]; then
  cp -aT /etc/skel /home/liveuser
  chown -R liveuser:liveuser /home/liveuser
fi
