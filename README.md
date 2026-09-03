# HongXingOS-ArchLinux

HongXingOS Linux 是基于 Arch Linux 技术栈构建的发行版项目。

当前阶段目标是先完成可启动、可联网、带 KDE Plasma 图形环境的 HongXingOS Dev Preview Live ISO，并建立后续安装器、品牌层、自有软件包和恢复机制的基础。

## 当前状态

- Arch Linux / archiso 基线
- KDE Plasma Live Desktop
- HongXingOS 品牌信息
- NetworkManager
- PipeWire
- Plymouth 启动画面基础
- GitHub Actions ISO 构建

## 构建

建议直接在 Arch Linux 构建环境中执行：

```bash
sudo pacman -Syu --needed archiso rsync
sudo ./build/build.sh
```

构建产物默认位于：

```text
out/
```

## 测试目标

第一阶段优先验证 VMware / UEFI：

1. ISO 可正常引导；
2. Live 用户可进入 KDE Plasma；
3. NetworkManager 可联网；
4. `cat /etc/os-release` 显示 HongXingOS；
5. `pacman -Syu` 正常工作；
6. Plymouth、SDDM、桌面背景使用一致的 HongXingOS 视觉资产。

## 项目定位

HongXingOS 当前采用 Arch 衍生发行版路线。上游负责 Linux、systemd、glibc、Mesa、KDE 等基础组件，HongXingOS 负责发行版配置、品牌、系统体验、安装/恢复工具及后续自有软件包。
