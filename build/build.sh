#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_DIR="$ROOT_DIR/work/profile"
ARCHISO_WORK_DIR="$ROOT_DIR/work/archiso"
OUT_DIR="$ROOT_DIR/out"
CONFIG_DIR="$ROOT_DIR/config"
BASE_PROFILE="${HXOS_ARCHISO_PROFILE:-baseline}"
SOURCE_PROFILE="/usr/share/archiso/configs/$BASE_PROFILE"

if [[ $EUID -ne 0 ]]; then
  echo "[ERR] HongXingOS ISO 构建需要 root 权限。"
  echo "      请执行: sudo ./build/build.sh"
  exit 1
fi

for cmd in mkarchiso rsync sed sort; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[ERR] 缺少构建命令: $cmd"
    echo "      Arch Linux: pacman -Syu --needed archiso rsync"
    exit 1
  fi
done

if [[ ! -d "$SOURCE_PROFILE" ]]; then
  echo "[ERR] 找不到 archiso profile: $SOURCE_PROFILE"
  exit 1
fi

rm -rf "$ROOT_DIR/work" "$OUT_DIR"
mkdir -p "$PROFILE_DIR" "$OUT_DIR"
cp -a "$SOURCE_PROFILE/." "$PROFILE_DIR/"

cat "$CONFIG_DIR/packages.x86_64.extra" >> "$PROFILE_DIR/packages.x86_64"
sort -u "$PROFILE_DIR/packages.x86_64" -o "$PROFILE_DIR/packages.x86_64"
rsync -a "$CONFIG_DIR/airootfs/" "$PROFILE_DIR/airootfs/"

sed -i 's/^iso_name=.*/iso_name="hongxingos"/' "$PROFILE_DIR/profiledef.sh"
sed -i 's/^iso_label=.*/iso_label="HONGXINGOS"/' "$PROFILE_DIR/profiledef.sh"
sed -i 's|^iso_publisher=.*|iso_publisher="HongXingOS <https://github.com/HX-Wrdzgzs/HongXingOS-ArchLinux>"|' "$PROFILE_DIR/profiledef.sh"
sed -i 's/^iso_application=.*/iso_application="HongXingOS 7 Dev Preview"/' "$PROFILE_DIR/profiledef.sh"
sed -i 's/^iso_version=.*/iso_version="7-dev"/' "$PROFILE_DIR/profiledef.sh"

if [[ -d "$PROFILE_DIR/syslinux" ]]; then
  find "$PROFILE_DIR/syslinux" -type f -name '*.cfg' -exec sed -i \
    -e 's/Arch Linux install medium/HongXingOS 7 Dev Preview/g' \
    -e 's/Arch Linux/HongXingOS/g' {} +
fi

if [[ -d "$PROFILE_DIR/efiboot" ]]; then
  find "$PROFILE_DIR/efiboot" -type f -name '*.conf' -exec sed -i \
    -e 's/Arch Linux install medium/HongXingOS 7 Dev Preview/g' \
    -e 's/Arch Linux/HongXingOS/g' {} +
fi

if [[ -d "$PROFILE_DIR/grub" ]]; then
  find "$PROFILE_DIR/grub" -type f \( -name '*.cfg' -o -name '*.conf' \) -exec sed -i \
    -e 's/Arch Linux install medium/HongXingOS 7 Dev Preview/g' \
    -e 's/Arch Linux/HongXingOS/g' {} +
fi

if [[ -d "$PROFILE_DIR/syslinux" ]]; then
  find "$PROFILE_DIR/syslinux" -type f -name '*.cfg' -exec sed -i -E \
    '/^[[:space:]]*APPEND[[:space:]]/ {/splash/! s/$/ quiet splash/}' {} +
fi
if [[ -d "$PROFILE_DIR/efiboot" ]]; then
  find "$PROFILE_DIR/efiboot" -type f -name '*.conf' -exec sed -i -E \
    '/^[[:space:]]*options[[:space:]]/ {/splash/! s/$/ quiet splash/}' {} +
fi
if [[ -d "$PROFILE_DIR/grub" ]]; then
  find "$PROFILE_DIR/grub" -type f -name '*.cfg' -exec sed -i -E \
    '/^[[:space:]]*linux[[:space:]]/ {/splash/! s/$/ quiet splash/}' {} +
fi

chmod +x "$PROFILE_DIR/airootfs/root/customize_airootfs.sh"
chmod +x "$PROFILE_DIR/airootfs/usr/local/bin/hongxingos-set-wallpaper"

echo "[INFO] Base profile : $BASE_PROFILE"
echo "[INFO] Profile      : $PROFILE_DIR"
echo "[INFO] Output       : $OUT_DIR"
echo "[INFO] Building HongXingOS 7 Dev Preview..."

mkarchiso -v -r -w "$ARCHISO_WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"

if compgen -G "$OUT_DIR/*.iso" >/dev/null; then
  (cd "$OUT_DIR" && sha256sum ./*.iso > SHA256SUMS)
  echo "[OK] ISO build complete."
  ls -lh "$OUT_DIR"/*.iso "$OUT_DIR/SHA256SUMS"
else
  echo "[ERR] mkarchiso finished without an ISO artifact."
  exit 1
fi
