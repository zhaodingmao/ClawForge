#!/usr/bin/env bash
set -Eeuo pipefail

NODE_VERSION="25.8.0"
OPENCLAW_NPM_PACKAGE="openclaw@latest"

LOCAL_PREFIX="${HOME}/.local"
BIN_DIR="${LOCAL_PREFIX}/bin"
NODE_INSTALL_ROOT="${LOCAL_PREFIX}/nodejs"
NODE_INSTALL_DIR="${NODE_INSTALL_ROOT}/node-v${NODE_VERSION}"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

echo "======================================"
echo "ClawForge Installer"
echo "OpenClaw AI Agent Setup"
echo "======================================"
echo

log() {
  echo "[INFO] $*"
}

warn() {
  echo "[WARN] $*" >&2
}

die() {
  echo "[ERROR] $*" >&2
  exit 1
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

detect_os() {
  case "$(uname -s)" in
    Linux) OS="linux" ;;
    Darwin) OS="darwin" ;;
    *) die "Unsupported OS: $(uname -s)" ;;
  esac
}

detect_arch() {
  case "$(uname -m)" in
    x86_64|amd64) ARCH="x64" ;;
    arm64|aarch64) ARCH="arm64" ;;
    *) die "Unsupported architecture: $(uname -m)" ;;
  esac
}

ensure_curl() {
  if has_cmd curl; then
    return
  fi

  if [ "${OS}" = "linux" ] && has_cmd sudo && has_cmd apt-get; then
    log "Installing curl..."
    sudo apt-get update
    sudo apt-get install -y curl
  else
    die "curl is required"
  fi
}

ensure_tar() {
  has_cmd tar || die "tar is required"
}

ensure_dirs() {
  mkdir -p "${BIN_DIR}" "${NODE_INSTALL_ROOT}"
}

download_and_install_node() {
  local filename=""
  local archive=""

  if [ "${OS}" = "linux" ]; then
    filename="node-v${NODE_VERSION}-${OS}-${ARCH}.tar.xz"
    archive="${TMP_DIR}/${filename}"

    if [ -x "${NODE_INSTALL_DIR}/bin/node" ]; then
      log "Node.js ${NODE_VERSION} already installed"
    else
      log "Downloading Node.js ${NODE_VERSION}..."
      curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/${filename}" -o "${archive}"

      log "Installing Node.js ${NODE_VERSION}..."
      mkdir -p "${NODE_INSTALL_ROOT}"
      tar -xJf "${archive}" -C "${NODE_INSTALL_ROOT}"
    fi
  else
    filename="node-v${NODE_VERSION}-${OS}-${ARCH}.tar.gz"
    archive="${TMP_DIR}/${filename}"

    if [ -x "${NODE_INSTALL_DIR}/bin/node" ]; then
      log "Node.js ${NODE_VERSION} already installed"
    else
      log "Downloading Node.js ${NODE_VERSION}..."
      curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/${filename}" -o "${archive}"

      log "Installing Node.js ${NODE_VERSION}..."
      mkdir -p "${NODE_INSTALL_ROOT}"
      tar -xzf "${archive}" -C "${NODE_INSTALL_ROOT}"
    fi
  fi

  ln -sf "${NODE_INSTALL_DIR}/bin/node" "${BIN_DIR}/node"
  ln -sf "${NODE_INSTALL_DIR}/bin/npm" "${BIN_DIR}/npm"
  ln -sf "${NODE_INSTALL_DIR}/bin/npx" "${BIN_DIR}/npx"
  ln -sf "${NODE_INSTALL_DIR}/bin/corepack" "${BIN_DIR}/corepack"

  export PATH="${BIN_DIR}:${PATH}"
}

append_path_once() {
  local rc_file="$1"
  local line='export PATH="$HOME/.local/bin:$PATH"'

  [ -f "${rc_file}" ] || touch "${rc_file}"

  if ! grep -Fq "${line}" "${rc_file}"; then
    printf '\n%s\n' "${line}" >> "${rc_file}"
    log "Added ${BIN_DIR} to ${rc_file}"
  fi
}

ensure_path() {
  export PATH="${BIN_DIR}:${PATH}"

  append_path_once "${HOME}/.bashrc"

  if [ -f "${HOME}/.zshrc" ]; then
    append_path_once "${HOME}/.zshrc"
  fi

  case ":${PATH}:" in
    *":${BIN_DIR}:"*) ;;
    *) die "Failed to add ${BIN_DIR} to PATH" ;;
  esac
}

configure_npm_prefix() {
  npm config set prefix "${LOCAL_PREFIX}" >/dev/null
}

enable_corepack() {
  corepack enable >/dev/null 2>&1 || true
}

install_openclaw() {
  log "Installing OpenClaw..."
  npm install -g "${OPENCLAW_NPM_PACKAGE}"
}

verify_install() {
  has_cmd node || die "node not found after installation"
  has_cmd npm || die "npm not found after installation"
  has_cmd openclaw || die "openclaw not found after installation"

  log "Node: $(node -v)"
  log "npm: $(npm -v)"
  log "OpenClaw: $(command -v openclaw)"
}

main() {
  detect_os
  detect_arch
  ensure_curl
  ensure_tar
  ensure_dirs
  ensure_path
  download_and_install_node
  configure_npm_prefix
  enable_corepack
  install_openclaw
  verify_install

  echo
  echo "OpenClaw installed."
  echo
  echo "Next step:"
  echo
  echo "  openclaw onboard --install-daemon"
  echo
  echo "If the current shell still can't find openclaw, run:"
  echo
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
}

main "$@"
