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

# base packages
if command -v apt-get >/dev/null 2>&1; then
  $SUDO apt-get update
  $SUDO apt-get install -y git curl zsh build-essential npm
fi

# zoxide install
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# set zsh default (be robust if $SHELL is unset and if chsh doesn't exist)
if command -v zsh >/dev/null 2>&1 && [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  if command -v chsh >/dev/null 2>&1; then
    $SUDO chsh -s "$(command -v zsh)" "$TARGET_USER" || true
  fi
fi

# Neovim from prebuilt archive
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
$SUDO rm -rf /opt/nvim-linux-x86_64
$SUDO tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# fzf install
if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  yes | "$HOME/.fzf/install" --no-update-rc || true
fi

