# HongXingOS-ArchLinux

HongXingOS Linux 是基于 Arch Linux 技术栈构建的发行版项目。

当前阶段目标是先完成可启动、可联网、带 KDE Plasma 图形环境的 HongXingOS Dev Preview Live ISO，并建立后续安装器、品牌层、自有软件包和恢复机制的基础。

## 当前状态

- Arch Linux / archiso `baseline` 基线
- KDE Plasma Live Desktop
- HongXingOS 品牌信息
- NetworkManager
- PipeWire
- VMware `open-vm-tools`
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

GitHub Actions 也会在 `main` 更新后自动构建 ISO，并上传构建 Artifact。

## VMware Dev Preview

当前 Live 环境用于第一轮调试：

```text
User: liveuser
Password: hongxing
```

SDDM 默认自动登录 `liveuser`，该用户拥有免密码 sudo。该账号只用于 Dev Preview，正式安装镜像会移除固定 Live 密码。

进入桌面后建议先执行：

```bash
hxdiag
```

它会一次输出系统标识、会话类型、SDDM / NetworkManager / VMware Tools 状态、网络、显卡、显示器信息以及本次启动的重要 warning，方便定位 VMware 首轮问题。

如果桌面进不去，也可以切换到 TTY 登录 `liveuser` 后执行：

```bash
hxdiag | tee ~/hxdiag.txt
```

## 测试目标

第一阶段优先验证 VMware / UEFI：

1. ISO 可正常引导；
2. Plymouth 是否显示且切换过程正常；
3. Live 用户是否自动进入 KDE Plasma；
4. NetworkManager 可联网；
5. `cat /etc/os-release` 显示 HongXingOS；
6. `pacman -Syu` 正常工作；
7. VMware Tools、动态分辨率和鼠标集成正常；
8. SDDM、桌面背景使用一致的 HongXingOS 视觉资产；
9. `hxdiag` 中没有影响启动和图形环境的关键错误。

## 项目定位

HongXingOS 当前采用 Arch 衍生发行版路线。上游负责 Linux、systemd、glibc、Mesa、KDE 等基础组件，HongXingOS 负责发行版配置、品牌、系统体验、安装/恢复工具及后续自有软件包。
