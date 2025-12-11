#!/usr/bin/env bash
set -euo pipefail

# figure out which user to operate on, even if $USER is unset
# if run via sudo: prefer the original user, else fall back to id -un
: "${USER:=$(id -un)}"
TARGET_USER="${SUDO_USER:-$USER}"

# sudo or root
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
elif command -v sudo >/dev/null 2>&1; then
  SUDO=sudo
else
  echo "Error: need root or sudo" >&2
  exit 1
fi

# base packages (Debian/Ubuntu)
if command -v apt-get >/dev/null 2>&1; then
  $SUDO apt-get update
  $SUDO apt-get install -y \
    git \
    curl \
    zsh \
    build-essential \
    unzip \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    cargo
fi

# Neovim from prebuilt archive (only if /opt/nvim-linux-x86_64 is missing)
if [ ! -x "/opt/nvim-linux-x86_64/bin/nvim" ]; then
  echo "Installing Neovim to /opt/nvim-linux-x86_64..."
  tmp="$(mktemp)"
  curl -fsSL -o "$tmp" \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  $SUDO rm -rf /opt/nvim-linux-x86_64
  $SUDO tar -C /opt -xzf "$tmp"
  rm -f "$tmp"
fi
