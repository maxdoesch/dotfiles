#!/usr/bin/env bash
set -euo pipefail

# NVM + Node.js 24
if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing nvm..."
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# shellcheck disable=SC1090
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  . "$HOME/.nvm/nvm.sh"
fi

if command -v nvm >/dev/null 2>&1; then
  if ! nvm ls 24 >/dev/null 2>&1; then
    echo "Installing Node.js 24 via nvm..."
    nvm install 24
  fi

  # make 24 the default (idempotent)
  nvm alias default 24 >/dev/null 2>&1 || true
else
  echo "Warning: nvm not found after install; skipping Node.js install." >&2
fi

# zoxide install (only if not already present)
if ! command -v zoxide >/dev/null 2>&1; then
  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# fzf install (only if ~/.fzf is missing)
if [ ! -d "$HOME/.fzf" ]; then
  echo "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  yes | "$HOME/.fzf/install" --no-update-rc || true
fi

