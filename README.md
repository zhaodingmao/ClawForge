
# ClawForge

<p align="center">

<b>ClawForge</b>
One-command installer for OpenClaw AI agents

</p>

<p align="center">

![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-blue)
![License](https://img.shields.io/badge/license-MIT-green.svg)

</p>

<p align="center">

🌐 Official Website [https://clawforge.com.cn](https://clawforge.com.cn)

</p>

---

# Overview

**ClawForge** 是一个用于 **快速部署 OpenClaw AI Agent** 的自动化安装工具。

ClawForge 的目标是让 OpenClaw 的安装变得非常简单：


---

# One-Command Install

### 1 安装 OpenClaw

Linux / macOS

```bash
curl -fsSL https://clawforge.com.cn/install.sh | bash
```

Windows

```powershell
irm https://clawforge.com.cn/install.ps1 | iex
```

---

### 2 运行 OpenClaw

安装完成后运行：

```bash
openclaw
```

---

# What ClawForge Does

运行安装脚本时会自动完成：

```
Detect platform
Install Git
Install Node.js
Clone OpenClaw repository
Install dependencies (npm install)
Create openclaw command
```

安装完成后可以直接启动 OpenClaw runtime。

---

# Requirements

ClawForge 会自动安装以下依赖：

```
Node.js
Git
npm dependencies
```

支持系统：

| Platform | Status    |
| -------- | --------- |
| Linux    | Supported |
| macOS    | Supported |
| Windows  | Supported |

---






---

# Contributing

欢迎提交 Issue 或 Pull Request。

---

# License

MIT License

---
