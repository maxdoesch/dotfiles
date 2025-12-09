#!/usr/bin/env bash
set -euo pipefail

# sometimes sudo does not exist
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
elif command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
else
  echo "Error: need root or sudo to install packages" >&2
  exit 1
fi


# Install basic packages (Debian/Ubuntu example)
if command -v apt-get >/dev/null 2>&1; then
  $SUDO apt-get update
  $SUDO apt-get install -y \
    git \
    curl \
    zsh \
    neovim \
    build-essential \
    npm
fi


# ensure zsh is default shell
if command -v zsh >/dev/null 2>&1; then
  if [ "$SHELL" != "$(command -v zsh)" ]; then
    chsh -s "$(command -v zsh)" "$USER" || true
  fi
fi

