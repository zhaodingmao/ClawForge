
# ClawForge

> Automated installer, builder and launcher for OpenClaw on Linux.

[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](#license)
[![Platform](https://img.shields.io/badge/platform-Linux-blue.svg)](#system-requirements)
[![Shell](https://img.shields.io/badge/shell-bash-black.svg)](#installation)
[![Engine](https://img.shields.io/badge/engine-OpenClaw-orange.svg)](#related-project)

---

# Overview

**ClawForge** 是一个用于在 Linux 上自动安装和运行 OpenClaw 的 CLI 工具。

OpenClaw 是经典游戏 **Captain Claw** 的开源重实现。

ClawForge 自动完成：

* 安装构建依赖
* 克隆 OpenClaw 源代码
* 自动编译游戏引擎
* 自动生成 `ASSETS.ZIP`
* 自动配置资源目录
* 创建统一启动命令
* 创建桌面启动器
* 支持更新 / 卸载 / 状态检查

目标是：

> 让 OpenClaw 在 Linux 上实现 **一键安装运行**

---

# Quick Install

```bash
git clone https://github.com/zhaodingmao/clawforge
cd clawforge
chmod +x clawforge.sh
./clawforge.sh install
```

如果你已经拥有游戏资源：

```bash
./clawforge.sh install --claw-rez /path/to/CLAW.REZ
```

安装完成后：

```bash
clawforge
```

---

# One-line Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/YOURNAME/clawforge/main/clawforge.sh | bash
```

---

# Related Project

ClawForge 使用的游戏引擎来自：

* OpenClaw

---

# System Requirements

支持系统：

* Ubuntu
* Debian
* Debian-based Linux

推荐版本：

* Ubuntu 22.04+
* Debian 11+

---

# Dependencies

ClawForge 会自动安装以下依赖：

```
build-essential
cmake
git
pkg-config
ninja-build
zip
unzip

libsdl2-dev
libsdl2-image-dev
libsdl2-mixer-dev
libsdl2-ttf-dev
libsdl2-gfx-dev
```

可选音频依赖：

```
timidity
freepats
```

---

# Installation Layout

默认安装结构：

```
/usr/local/bin/clawforge
/usr/local/bin/clawforge-openclaw.real

/usr/local/share/clawforge/install-manifest.txt

~/.local/share/clawforge
   ├── CLAW.REZ
   └── ASSETS.ZIP

~/.local/state/clawforge/install.log
```

---

# Usage

## Install

```
./clawforge.sh install
```

## Update

```
./clawforge.sh update
```

## Status

```
./clawforge.sh status
```

## Uninstall

```
./clawforge.sh uninstall
```

---

# CLI Options

| Option                 | Description                  |
| ---------------------- | ---------------------------- |
| `--prefix DIR`         | installation prefix          |
| `--src-dir DIR`        | source directory             |
| `--build-dir DIR`      | build directory              |
| `--asset-dir DIR`      | asset directory              |
| `--repo-url URL`       | OpenClaw repository          |
| `--branch REF`         | git branch                   |
| `--claw-rez FILE`      | import CLAW.REZ              |
| `--install-audio-deps` | install audio dependencies   |
| `--no-install-deps`    | skip dependency installation |
| `--clean-build`        | force rebuild                |
| `--non-interactive`    | CI mode                      |

---

# Game Resources

ClawForge **不会包含游戏资源**。

你必须提供：

```
CLAW.REZ
```

来自合法的 Captain Claw 游戏副本。

资源目录：

```
~/.local/share/clawforge
```

---

# Desktop Launcher

安装后会自动生成：

```
~/.local/share/applications/clawforge.desktop
```

你可以在系统应用菜单启动 **ClawForge**。

---

# Architecture

ClawForge 工作流程：

```
System detection
     │
Install dependencies
     │
Clone OpenClaw
     │
CMake build
     │
Generate ASSETS.ZIP
     │
Install engine binary
     │
Create wrapper command
     │
Launch OpenClaw
```

启动命令：

```
clawforge
```

包装器会：

* 切换到资源目录
* 检查 `CLAW.REZ`
* 启动 OpenClaw 引擎

---

# Troubleshooting

### 游戏无法启动

检查：

```
~/.local/share/clawforge/CLAW.REZ
```

---

### 没有声音

安装音频依赖：

```
sudo apt install timidity freepats
```

或重新安装：

```
./clawforge.sh install --install-audio-deps
```

---

### 构建失败

尝试：

```
./clawforge.sh update --clean-build
```

---

# Advanced Usage

指定安装路径：

```
./clawforge.sh install --prefix /opt/clawforge
```

指定分支：

```
./clawforge.sh install --branch master
```

CI 模式：

```
./clawforge.sh install --non-interactive
```

---

# Automation Example

```
sudo ./clawforge.sh install \
  --install-audio-deps \
  --claw-rez /opt/assets/CLAW.REZ \
  --non-interactive
```

---

# Roadmap

未来计划：

* 自动生成 `.deb`
* 支持 Arch Linux
* 支持 Fedora
* 自动 Release 下载
* AppImage 打包
* 自动更新机制

---

# Contributing

欢迎贡献代码。

流程：

1. Fork repository
2. 创建 feature branch
3. 提交 commit
4. 提交 Pull Request

---

# License

ClawForge 使用 MIT License。

OpenClaw 使用其原始许可证。

---

# Security

ClawForge：

* 不下载游戏资源
* 不修改系统关键组件
* 所有文件可通过 `uninstall` 移除
* 所有安装状态可通过 `status` 查看

---

# Disclaimer

ClawForge 不包含任何 Captain Claw 游戏资源。

用户必须从合法渠道获得游戏文件。

---

