#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

###############################################################################
# ClawForge
# Automated installer / updater / launcher wrapper for OpenClaw
# Target: Debian / Ubuntu family
###############################################################################

SCRIPT_NAME="$(basename "$0")"
VERSION="1.2.0"

###############################################################################
# Defaults
###############################################################################
ACTION="install"
REPO_URL="https://github.com/pjasicek/OpenClaw.git"
BRANCH="master"

PREFIX="/usr/local"
SRC_DIR="${HOME}/.local/src/OpenClaw"
BUILD_DIR="${SRC_DIR}/build"
ASSET_DIR="${HOME}/.local/share/clawforge"
LOG_DIR="${HOME}/.local/state/clawforge"
LOG_FILE="${LOG_DIR}/install.log"

INSTALL_DEPS="true"
INSTALL_AUDIO_DEPS="false"
CREATE_DESKTOP_ENTRY="true"
CREATE_WRAPPER="true"
FORCE_CLEAN_BUILD="false"
NONINTERACTIVE="false"

CLAW_REZ_SOURCE=""

APP_NAME="ClawForge"
WRAPPER_NAME="clawforge"
DESKTOP_FILE="${HOME}/.local/share/applications/clawforge.desktop"
WRAPPER_PATH="${PREFIX}/bin/${WRAPPER_NAME}"
REAL_BIN_PATH="${PREFIX}/bin/clawforge-openclaw.real"
STATE_FILE="${PREFIX}/share/clawforge/install-manifest.txt"

###############################################################################
# Colors
###############################################################################
if [[ -t 1 ]]; then
  C_RESET='\033[0m'
  C_RED='\033[1;31m'
  C_GREEN='\033[1;32m'
  C_YELLOW='\033[1;33m'
  C_BLUE='\033[1;34m'
else
  C_RESET=''
  C_RED=''
  C_GREEN=''
  C_YELLOW=''
  C_BLUE=''
fi

###############################################################################
# Logging
###############################################################################
mkdir -p "${LOG_DIR}"

log() {
  echo -e "${C_GREEN}[INFO]${C_RESET} $*" | tee -a "${LOG_FILE}"
}

warn() {
  echo -e "${C_YELLOW}[WARN]${C_RESET} $*" | tee -a "${LOG_FILE}" >&2
}

error() {
  echo -e "${C_RED}[ERROR]${C_RESET} $*" | tee -a "${LOG_FILE}" >&2
}

die() {
  error "$*"
  exit 1
}

trap 'error "脚本在第 ${LINENO} 行失败。详细日志：${LOG_FILE}"' ERR

###############################################################################
# Usage
###############################################################################
usage() {
  cat <<EOF
${SCRIPT_NAME} v${VERSION}

用法:
  ${SCRIPT_NAME} [action] [options]

action:
  install        安装 ClawForge / OpenClaw（默认）
  update         更新源码并重新编译安装
  uninstall      卸载安装内容
  status         查看安装状态
  help           显示帮助

options:
  --prefix DIR               安装前缀，默认: ${PREFIX}
  --src-dir DIR              源码目录，默认: ${SRC_DIR}
  --build-dir DIR            构建目录，默认: ${BUILD_DIR}
  --asset-dir DIR            资源目录，默认: ${ASSET_DIR}
  --repo-url URL             仓库地址，默认: ${REPO_URL}
  --branch REF               分支/标签/提交，默认: ${BRANCH}
  --claw-rez FILE            原版 CLAW.REZ 路径，安装时自动复制

  --install-deps             安装依赖（默认开启）
  --no-install-deps          跳过依赖安装
  --install-audio-deps       安装 timidity / freepats
  --no-desktop-entry         不创建 desktop entry
  --no-wrapper               不创建启动包装器
  --clean-build              清理后重新构建
  --non-interactive          非交互模式
  --help, -h                 显示帮助

示例:
  ${SCRIPT_NAME} install --install-audio-deps --claw-rez ~/games/CLAW.REZ
  ${SCRIPT_NAME} update --clean-build
  ${SCRIPT_NAME} status
  ${SCRIPT_NAME} uninstall
EOF
}

###############################################################################
# Helpers
###############################################################################
require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "缺少命令: $1"
}

need_sudo() {
  require_cmd sudo
  if [[ "${NONINTERACTIVE}" == "true" ]]; then
    sudo -n true 2>/dev/null || die "需要 sudo 权限，但当前非交互模式下无法提权。"
  else
    sudo -v
  fi
}

confirm() {
  local prompt="$1"
  if [[ "${NONINTERACTIVE}" == "true" ]]; then
    return 0
  fi
  read -r -p "${prompt} [y/N]: " ans
  [[ "${ans:-}" =~ ^[Yy]$ ]]
}

canonicalize_defaults() {
  BUILD_DIR="${BUILD_DIR:-${SRC_DIR}/build}"
  DESKTOP_FILE="${HOME}/.local/share/applications/clawforge.desktop"
  WRAPPER_PATH="${PREFIX}/bin/${WRAPPER_NAME}"
  REAL_BIN_PATH="${PREFIX}/bin/clawforge-openclaw.real"
  STATE_FILE="${PREFIX}/share/clawforge/install-manifest.txt"
}

parse_args() {
  if [[ $# -gt 0 ]]; then
    case "$1" in
      install|update|uninstall|status|help)
        ACTION="$1"
        shift
        ;;
    esac
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --prefix)
        [[ $# -ge 2 ]] || die "$1 缺少参数"
        PREFIX="$2"; shift 2 ;;
      --src-dir)
        [[ $# -ge 2 ]] || die "$1 缺少参数"
        SRC_DIR="$2"; shift 2 ;;
      --build-dir)
        [[ $# -ge 2 ]] || die "$1 缺少参数"
        BUILD_DIR="$2"; shift 2 ;;
      --asset-dir)
        [[ $# -ge 2 ]] || die "$1 缺少参数"
        ASSET_DIR="$2"; shift 2 ;;
      --repo-url)
        [[ $# -ge 2 ]] || die "$1 缺少参数"
        REPO_URL="$2"; shift 2 ;;
      --branch)
        [[ $# -ge 2 ]] || die "$1 缺少参数"
        BRANCH="$2"; shift 2 ;;
      --claw-rez)
        [[ $# -ge 2 ]] || die "$1 缺少参数"
        CLAW_REZ_SOURCE="$2"; shift 2 ;;
      --install-deps)
        INSTALL_DEPS="true"; shift ;;
      --no-install-deps)
        INSTALL_DEPS="false"; shift ;;
      --install-audio-deps)
        INSTALL_AUDIO_DEPS="true"; shift ;;
      --no-desktop-entry)
        CREATE_DESKTOP_ENTRY="false"; shift ;;
      --no-wrapper)
        CREATE_WRAPPER="false"; shift ;;
      --clean-build)
        FORCE_CLEAN_BUILD="true"; shift ;;
      --non-interactive)
        NONINTERACTIVE="true"; shift ;;
      --help|-h)
        ACTION="help"; shift ;;
      *)
        die "未知参数: $1"
        ;;
    esac
  done

  canonicalize_defaults
}

detect_os() {
  [[ -f /etc/os-release ]] || die "无法识别系统：缺少 /etc/os-release"
  # shellcheck disable=SC1091
  source /etc/os-release

  case "${ID:-}" in
    ubuntu|debian)
      PKG_FAMILY="debian"
      ;;
    *)
      if [[ "${ID_LIKE:-}" == *debian* ]]; then
        PKG_FAMILY="debian"
      else
        die "当前仅支持 Debian / Ubuntu 系。检测到: ${ID:-unknown}"
      fi
      ;;
  esac

  log "系统检测: ${PRETTY_NAME:-unknown}"
}

prepare_dirs() {
  mkdir -p "${ASSET_DIR}"
  mkdir -p "${LOG_DIR}"
  mkdir -p "$(dirname "${DESKTOP_FILE}")"
  mkdir -p "$(dirname "${SRC_DIR}")"
}

apt_install() {
  local packages=("$@")
  sudo apt-get update
  sudo apt-get install -y "${packages[@]}"
}

install_dependencies() {
  [[ "${INSTALL_DEPS}" == "true" ]] || {
    warn "已跳过依赖安装。"
    return 0
  }

  log "安装编译依赖..."
  apt_install \
    build-essential \
    cmake \
    git \
    pkg-config \
    ninja-build \
    zip \
    unzip \
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    libsdl2-ttf-dev \
    libsdl2-gfx-dev

  log "安装补充依赖（如存在）..."
  sudo apt-get install -y \
    libgl1-mesa-dev \
    libasound2-dev \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    ca-certificates || true

  if [[ "${INSTALL_AUDIO_DEPS}" == "true" ]]; then
    log "安装可选音频依赖 timidity / freepats..."
    sudo apt-get install -y timidity freepats || \
      warn "可选音频依赖安装失败，背景音乐可能不可用。"
  fi
}

clone_or_update_repo() {
  require_cmd git

  if [[ -d "${SRC_DIR}/.git" ]]; then
    log "检测到已有源码，执行更新..."
    git -C "${SRC_DIR}" remote set-url origin "${REPO_URL}" || true
    git -C "${SRC_DIR}" fetch --all --tags
    git -C "${SRC_DIR}" checkout "${BRANCH}"
    git -C "${SRC_DIR}" pull --ff-only || warn "pull 失败，继续使用本地代码。"
  else
    log "克隆仓库到 ${SRC_DIR} ..."
    rm -rf "${SRC_DIR}"
    git clone "${REPO_URL}" "${SRC_DIR}"
    git -C "${SRC_DIR}" checkout "${BRANCH}"
  fi

  local commit
  commit="$(git -C "${SRC_DIR}" rev-parse --short HEAD)"
  log "当前源码版本: ${commit}"
}

guess_binary_path() {
  local candidates=(
    "${BUILD_DIR}/openclaw"
    "${BUILD_DIR}/OpenClaw"
    "${BUILD_DIR}/captainclaw"
    "${BUILD_DIR}/CaptainClaw"
    "${SRC_DIR}/Build_Release/openclaw"
    "${SRC_DIR}/Build_Release/OpenClaw"
    "${SRC_DIR}/Build_Release/captainclaw"
    "${SRC_DIR}/Build_Release/CaptainClaw"
  )

  local f
  for f in "${candidates[@]}"; do
    if [[ -x "$f" ]]; then
      echo "$f"
      return 0
    fi
  done

  return 1
}

configure_build() {
  if [[ "${FORCE_CLEAN_BUILD}" == "true" ]]; then
    log "清理构建目录: ${BUILD_DIR}"
    rm -rf "${BUILD_DIR}"
  fi

  mkdir -p "${BUILD_DIR}"

  log "尝试使用 CMake + Ninja 配置..."
  if cmake -S "${SRC_DIR}" -B "${BUILD_DIR}" -G Ninja -DCMAKE_BUILD_TYPE=Release; then
    BUILD_SYSTEM="cmake"
    return 0
  fi

  warn "标准 out-of-source CMake 配置失败，回退到 Build_Release..."
  mkdir -p "${SRC_DIR}/Build_Release"
  if cmake -S "${SRC_DIR}" -B "${SRC_DIR}/Build_Release" -DCMAKE_BUILD_TYPE=Release; then
    BUILD_DIR="${SRC_DIR}/Build_Release"
    BUILD_SYSTEM="cmake"
    return 0
  fi

  die "CMake 配置失败，无法继续。"
}

build_project() {
  local jobs
  jobs="$(nproc 2>/dev/null || echo 2)"

  case "${BUILD_SYSTEM:-}" in
    cmake)
      log "开始编译..."
      cmake --build "${BUILD_DIR}" -- -j"${jobs}"
      ;;
    *)
      die "未知构建系统: ${BUILD_SYSTEM:-unset}"
      ;;
  esac
}

install_claw_rez() {
  if [[ -z "${CLAW_REZ_SOURCE}" ]]; then
    log "未提供 --claw-rez，跳过资源导入。"
    return 0
  fi

  [[ -f "${CLAW_REZ_SOURCE}" ]] || die "--claw-rez 指定的文件不存在: ${CLAW_REZ_SOURCE}"

  log "复制 CLAW.REZ 到 ${ASSET_DIR}/CLAW.REZ"
  install -m 0644 "${CLAW_REZ_SOURCE}" "${ASSET_DIR}/CLAW.REZ"
}

package_assets_zip() {
  local source_assets_dir="${SRC_DIR}/Build_Release/ASSETS"
  local output_zip="${ASSET_DIR}/ASSETS.ZIP"

  if [[ ! -d "${source_assets_dir}" ]]; then
    warn "未找到 ${source_assets_dir}，跳过生成 ASSETS.ZIP"
    return 0
  fi

  require_cmd zip

  log "从 ${source_assets_dir} 生成 ${output_zip}"
  rm -f "${output_zip}"

  (
    cd "${source_assets_dir}"
    zip -qr "${output_zip}" .
  )

  if [[ -f "${output_zip}" ]]; then
    log "已生成资源包: ${output_zip}"
  else
    warn "ASSETS.ZIP 生成失败。"
  fi
}

create_wrapper() {
  [[ "${CREATE_WRAPPER}" == "true" ]] || {
    warn "跳过包装器创建。"
    return 0
  }

  local built_bin
  built_bin="$(guess_binary_path || true)"
  [[ -n "${built_bin}" ]] || die "无法定位编译产物，不能创建包装器。"

  log "安装真实二进制到 ${REAL_BIN_PATH}"
  sudo mkdir -p "${PREFIX}/bin"
  sudo install -m 0755 "${built_bin}" "${REAL_BIN_PATH}"

  local tmp_wrapper
  tmp_wrapper="$(mktemp)"

  cat > "${tmp_wrapper}" <<EOF
#!/usr/bin/env bash
set -euo pipefail

ASSET_DIR="${ASSET_DIR}"
REAL_BIN="${REAL_BIN_PATH}"

if [[ ! -x "\${REAL_BIN}" ]]; then
  echo "ClawForge 运行目标不存在: \${REAL_BIN}" >&2
  exit 1
fi

cd "\${ASSET_DIR}"

if [[ ! -f "CLAW.REZ" ]]; then
  echo "缺少资源文件 CLAW.REZ" >&2
  echo "请把原版游戏中的 CLAW.REZ 放到: \${ASSET_DIR}" >&2
  exit 2
fi

exec "\${REAL_BIN}" "\$@"
EOF

  sudo install -m 0755 "${tmp_wrapper}" "${WRAPPER_PATH}"
  rm -f "${tmp_wrapper}"

  log "已创建启动包装器: ${WRAPPER_PATH}"
}

create_desktop_entry() {
  [[ "${CREATE_DESKTOP_ENTRY}" == "true" ]] || {
    warn "跳过 desktop entry 创建。"
    return 0
  }

  log "创建 desktop entry: ${DESKTOP_FILE}"
  cat > "${DESKTOP_FILE}" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=${APP_NAME}
Comment=OpenClaw deployment and launcher
Exec=${WRAPPER_PATH}
Icon=applications-games
Terminal=false
Categories=Game;Utility;
StartupNotify=true
EOF

  chmod 0644 "${DESKTOP_FILE}"
}

write_manifest() {
  local built_bin
  built_bin="$(guess_binary_path || true)"

  log "写入安装清单: ${STATE_FILE}"
  sudo mkdir -p "$(dirname "${STATE_FILE}")"

  local tmp_manifest
  tmp_manifest="$(mktemp)"

  cat > "${tmp_manifest}" <<EOF
ACTION=install
VERSION=${VERSION}
PREFIX=${PREFIX}
SRC_DIR=${SRC_DIR}
BUILD_DIR=${BUILD_DIR}
ASSET_DIR=${ASSET_DIR}
REPO_URL=${REPO_URL}
BRANCH=${BRANCH}
CLAW_REZ_SOURCE=${CLAW_REZ_SOURCE}
WRAPPER_PATH=${WRAPPER_PATH}
REAL_BIN_PATH=${REAL_BIN_PATH}
DESKTOP_FILE=${DESKTOP_FILE}
BUILT_BIN=${built_bin}
EOF

  sudo install -m 0644 "${tmp_manifest}" "${STATE_FILE}"
  rm -f "${tmp_manifest}"
}

check_assets() {
  [[ -f "${ASSET_DIR}/CLAW.REZ" ]] && log "已检测到 CLAW.REZ" || warn "未检测到 CLAW.REZ"
  [[ -f "${ASSET_DIR}/ASSETS.ZIP" ]] && log "已检测到 ASSETS.ZIP" || warn "未检测到 ASSETS.ZIP"
}

show_status() {
  echo "ClawForge 状态"
  echo "----------------------------------------"
  echo "PREFIX      : ${PREFIX}"
  echo "SRC_DIR     : ${SRC_DIR}"
  echo "BUILD_DIR   : ${BUILD_DIR}"
  echo "ASSET_DIR   : ${ASSET_DIR}"
  echo "WRAPPER     : ${WRAPPER_PATH}"
  echo "REAL_BIN    : ${REAL_BIN_PATH}"
  echo "DESKTOP     : ${DESKTOP_FILE}"
  echo "STATE_FILE  : ${STATE_FILE}"
  echo

  if [[ -f "${STATE_FILE}" ]]; then
    echo "[安装清单]"
    sudo cat "${STATE_FILE}" 2>/dev/null || cat "${STATE_FILE}" || true
    echo
  else
    echo "[安装清单] 未找到"
    echo
  fi

  [[ -x "${WRAPPER_PATH}" ]] && echo "[OK] 包装器存在" || echo "[NO] 包装器不存在"
  [[ -x "${REAL_BIN_PATH}" ]] && echo "[OK] 真实二进制存在" || echo "[NO] 真实二进制不存在"
  [[ -f "${DESKTOP_FILE}" ]] && echo "[OK] desktop entry 存在" || echo "[NO] desktop entry 不存在"
  [[ -f "${ASSET_DIR}/CLAW.REZ" ]] && echo "[OK] CLAW.REZ 已就绪" || echo "[NO] 缺少 CLAW.REZ"
  [[ -f "${ASSET_DIR}/ASSETS.ZIP" ]] && echo "[OK] ASSETS.ZIP 已就绪" || echo "[NO] 缺少 ASSETS.ZIP"
}

uninstall_clawforge() {
  need_sudo

  warn "将卸载以下内容:"
  echo "  ${WRAPPER_PATH}"
  echo "  ${REAL_BIN_PATH}"
  echo "  ${STATE_FILE}"
  echo "  ${DESKTOP_FILE}"
  echo
  warn "源码目录和资源目录默认不会删除:"
  echo "  ${SRC_DIR}"
  echo "  ${ASSET_DIR}"
  echo

  confirm "确认卸载?" || {
    log "已取消卸载。"
    return 0
  }

  sudo rm -f "${WRAPPER_PATH}" || true
  sudo rm -f "${REAL_BIN_PATH}" || true
  sudo rm -f "${STATE_FILE}" || true
  rm -f "${DESKTOP_FILE}" || true

  log "卸载完成。"
  warn "如需彻底清理，可手动删除："
  echo "  rm -rf '${SRC_DIR}'"
  echo "  rm -rf '${ASSET_DIR}'"
}

print_post_install() {
  cat <<EOF

安装完成。

启动命令:
  ${WRAPPER_PATH}

资源目录:
  ${ASSET_DIR}

建议检查:
  ${ASSET_DIR}/CLAW.REZ
  ${ASSET_DIR}/ASSETS.ZIP

状态查看:
  ${SCRIPT_NAME} status

EOF
}

run_install() {
  detect_os
  need_sudo
  prepare_dirs
  install_dependencies
  clone_or_update_repo
  configure_build
  build_project
  install_claw_rez
  package_assets_zip
  create_wrapper
  create_desktop_entry
  write_manifest
  check_assets
  print_post_install
}

run_update() {
  FORCE_CLEAN_BUILD="true"
  run_install
}

main() {
  parse_args "$@"

  case "${ACTION}" in
    install)
      run_install
      ;;
    update)
      run_update
      ;;
    uninstall)
      uninstall_clawforge
      ;;
    status)
      show_status
      ;;
    help)
      usage
      ;;
    *)
      die "未知 action: ${ACTION}"
      ;;
  esac
}

main "$@"