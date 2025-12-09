#!/usr/bin/env bash
set -euo pipefail

# sudo or root
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
elif command -v sudo >/dev/null 2>&1; then
  SUDO=sudo
else
  echo "Error: need root or sudo" >&2
  exit 1
fi

# base packages
if command -v apt-get >/dev/null 2>&1; then
  $SUDO apt-get update
  $SUDO apt-get install -y git curl zsh build-essential npm
fi

# set zsh default
if command -v zsh >/dev/null 2>&1 && [ "$SHELL" != "$(command -v zsh)" ]; then
  $SUDO chsh -s "$(command -v zsh)" "$USER" || true
fi

# Neovim from prebuilt archive
NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
INSTALL_DIR="/usr/local/nvim"
TMP="$(mktemp)"

curl -L "$NVIM_URL" -o "$TMP"
$SUDO rm -rf "$INSTALL_DIR"
$SUDO mkdir -p "$INSTALL_DIR"
$SUDO tar -xzf "$TMP" -C "$INSTALL_DIR" --strip-components=1
rm "$TMP"

# fzf install
if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  yes | "$HOME/.fzf/install" --no-update-rc
fi
