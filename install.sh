#!/usr/bin/env bash
set -e

OPENCLAW_REPO="https://github.com/openclaw/openclaw.git"
INSTALL_DIR="$HOME/.openclaw"
BIN_DIR="$HOME/.local/bin"

echo "======================================"
echo "ClawForge Installer"
echo "OpenClaw AI Agent Setup"
echo "======================================"
echo

detect_os() {
case "$(uname -s)" in
Linux) OS="linux" ;;
Darwin) OS="macos" ;;
*) echo "Unsupported OS"; exit 1 ;;
esac
}

install_node() {

if command -v node >/dev/null; then
    echo "Node.js already installed"
    return
fi

echo "Installing Node.js..."

if [ "$OS" = "linux" ]; then
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
else
brew install node
fi
}

install_git() {

if command -v git >/dev/null; then
    return
fi

if [ "$OS" = "linux" ]; then
sudo apt install -y git
else
brew install git
fi
}

install_openclaw() {

if [ -d "$INSTALL_DIR" ]; then
echo "Updating OpenClaw..."
git -C "$INSTALL_DIR" pull
else
echo "Cloning OpenClaw..."
git clone "$OPENCLAW_REPO" "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

npm install
}

create_wrapper() {

mkdir -p "$BIN_DIR"

WRAPPER="$BIN_DIR/openclaw"

cat > "$WRAPPER" <<EOF
#!/usr/bin/env bash
cd "$INSTALL_DIR"
npm start
EOF

chmod +x "$WRAPPER"

echo
echo "OpenClaw installed."
echo
echo "Run:"
echo
echo "openclaw"
}

detect_os
install_git
install_node
install_openclaw
create_wrapper