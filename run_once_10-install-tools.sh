#!/usr/bin/env bash
set -euo pipefail

# Install basic packages (Debian/Ubuntu example)
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y \
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

