
# ClawForge

**ClawForge** 是一个用于 **自动安装、构建和运行 OpenClaw 的 CLI 工具**。

它可以自动完成以下流程：

* 安装 OpenClaw 编译依赖
* 克隆 OpenClaw 源代码
* 自动编译游戏引擎
* 自动配置资源目录
* 自动生成 `ASSETS.ZIP`
* 创建启动包装器
* 提供统一命令 `clawforge`
* 支持更新 / 卸载 / 状态检查

ClawForge 主要解决的问题是：
**OpenClaw 在 Linux 上安装流程复杂，需要手动构建和整理资源。**

ClawForge 将整个流程自动化。

---

# Features

* 一键安装 OpenClaw
* 自动安装 SDL2 依赖
* 自动编译源码
* 自动生成 `ASSETS.ZIP`
* 自动创建启动命令
* 自动创建 Desktop Launcher
* 支持更新 OpenClaw
* 支持卸载
* 提供安装状态检测
* CLI 参数控制

---

# System Requirements

当前支持系统：

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

可选音频支持：

```
timidity
freepats
```

---

# Installation

下载脚本：

```bash
git clone https://github.com/YOURNAME/clawforge
cd clawforge
```

赋予执行权限：

```bash
chmod +x clawforge.sh
```

运行安装：

```bash
./clawforge.sh install
```

如果你已经拥有原版 `CLAW.REZ`：

```bash
./clawforge.sh install --claw-rez /path/to/CLAW.REZ
```

安装完成后可以直接运行：

```bash
clawforge
```

---

# Game Resources

OpenClaw **不包含原版游戏资源**。

你需要提供：

```
CLAW.REZ
```

来自原版 **Captain Claw** 游戏。

资源会放置在：

```
~/.local/share/clawforge
```

目录结构：

```
~/.local/share/clawforge
 ├── CLAW.REZ
 └── ASSETS.ZIP
```

---

# Usage

## 安装

```bash
./clawforge.sh install
```

## 更新 OpenClaw

```bash
./clawforge.sh update
```

## 查看状态

```bash
./clawforge.sh status
```

## 卸载

```bash
./clawforge.sh uninstall
```

---

# Command Line Options

```
--prefix DIR
安装前缀 (默认: /usr/local)

--src-dir DIR
源码目录

--build-dir DIR
构建目录

--asset-dir DIR
资源目录

--repo-url URL
OpenClaw 仓库地址

--branch REF
Git 分支

--claw-rez FILE
自动导入 CLAW.REZ

--install-audio-deps
安装音频依赖

--no-install-deps
跳过依赖安装

--clean-build
重新构建

--non-interactive
无交互模式
```

---

# Install Layout

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

# Desktop Launcher

安装后会自动创建：

```
~/.local/share/applications/clawforge.desktop
```

你可以在应用菜单中找到 **ClawForge**。

---

# Example

完整安装示例：

```bash
./clawforge.sh install \
  --install-audio-deps \
  --claw-rez ~/games/CLAW.REZ
```

更新：

```bash
./clawforge.sh update
```

---

# Troubleshooting

### 游戏无法启动

检查资源：

```
~/.local/share/clawforge/CLAW.REZ
```

### 没有声音

安装音频依赖：

```bash
sudo apt install timidity freepats
```

或重新安装：

```bash
./clawforge.sh install --install-audio-deps
```

### 构建失败

尝试重新构建：

```bash
./clawforge.sh update --clean-build
```

---

# Project Structure

```
clawforge
 ├── clawforge.sh
 ├── README.md
 └── LICENSE
```

---

# Related Project

ClawForge 使用的游戏引擎来自：

* OpenClaw

---

# License

ClawForge 使用 MIT License。

OpenClaw 使用其原始仓库许可证。

---

# Disclaimer

ClawForge **不包含任何游戏资源**。

你必须从合法渠道获得 **Captain Claw** 原版资源。

---

如果你愿意，我可以再帮你**升级 README 到“专业开源项目级别”**，包括：

* README 徽章（build / license / version）
* 自动安装一行命令
* GIF 演示
* CLI help 表格
* GitHub Release 下载
* `.deb` 安装包说明

那一版会更像 **成熟开源项目主页**。
