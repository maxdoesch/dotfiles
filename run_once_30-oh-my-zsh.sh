#!/usr/bin/env bash
set -euo pipefail

# Install oh-my-zsh only once
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# figure out which user to operate on, even if $USER is unset
: "${USER:=$(id -un)}"
TARGET_USER="${SUDO_USER:-$USER}"

# sudo or root (best-effort; if no sudo, just skip chsh)
if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
elif command -v sudo >/dev/null 2>&1; then
  SUDO=sudo
else
  SUDO=""
fi

# set zsh as default shell (idempotent)
if command -v zsh >/dev/null 2>&1 && [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  if command -v chsh >/dev/null 2>&1; then
    echo "Setting zsh as login shell for $TARGET_USER..."
    $SUDO chsh -s "$(command -v zsh)" "$TARGET_USER" || true
  fi
fi
