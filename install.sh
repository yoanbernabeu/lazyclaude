#!/bin/bash
set -e

REPO="yoanbernabeu/lazyclaude"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_PATH="$INSTALL_DIR/lazyclaude"
TMUX_CONF_PATH="$HOME/.tmux.conf"

echo ""
echo "  ╔═══════════════════════════╗"
echo "  ║       🦥 LazyClaude       ║"
echo "  ╚═══════════════════════════╝"
echo ""

# Check dependencies
missing=()
command -v tmux >/dev/null 2>&1 || missing+=("tmux")
command -v claude >/dev/null 2>&1 || missing+=("claude (Claude Code)")
command -v lazygit >/dev/null 2>&1 || missing+=("lazygit")
command -v yazi >/dev/null 2>&1 || missing+=("yazi")
command -v micro >/dev/null 2>&1 || missing+=("micro")

if [ ${#missing[@]} -gt 0 ]; then
  echo "⚠️  Missing dependencies:"
  for dep in "${missing[@]}"; do
    echo "  - $dep"
  done
  echo ""
  echo "Install them first:"
  echo "  brew install tmux lazygit yazi micro"
  echo "  npm install -g @anthropic-ai/claude-code"
  echo ""
fi

# Create ~/.local/bin if needed
mkdir -p "$INSTALL_DIR"

# Download and install the script
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$BASE_URL/lazyclaude" -o "$SCRIPT_PATH"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$SCRIPT_PATH" "$BASE_URL/lazyclaude"
else
  echo "❌ curl or wget is required."
  exit 1
fi
chmod +x "$SCRIPT_PATH"
echo "✅ lazyclaude installed to $SCRIPT_PATH"

# Install tmux config
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$BASE_URL/tmux.conf" -o "$TMUX_CONF_PATH"
else
  wget -qO "$TMUX_CONF_PATH" "$BASE_URL/tmux.conf"
fi
echo "✅ ~/.tmux.conf installed."

# Install lazygit config
LAZYGIT_CONF_DIR="$HOME/.config/lazygit"
LAZYGIT_CONF_PATH="$LAZYGIT_CONF_DIR/config.yml"
mkdir -p "$LAZYGIT_CONF_DIR"
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$BASE_URL/lazygit.yml" -o "$LAZYGIT_CONF_PATH"
else
  wget -qO "$LAZYGIT_CONF_PATH" "$BASE_URL/lazygit.yml"
fi
echo "✅ ~/.config/lazygit/config.yml installed."

# Install yazi config
YAZI_CONF_DIR="$HOME/.config/yazi"
YAZI_CONF_PATH="$YAZI_CONF_DIR/yazi.toml"
mkdir -p "$YAZI_CONF_DIR"
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$BASE_URL/yazi.toml" -o "$YAZI_CONF_PATH"
else
  wget -qO "$YAZI_CONF_PATH" "$BASE_URL/yazi.toml"
fi
echo "✅ ~/.config/yazi/yazi.toml installed."


# Check PATH
if ! echo "$PATH" | tr ':' '\n' | grep -q "$HOME/.local/bin"; then
  echo ""
  echo "⚠️  ~/.local/bin is not in your PATH."
  echo "   Run this command to add it to your shell config:"
  echo ""
  # Detect user's shell config file
  case "$(basename "$SHELL")" in
    zsh)  shell_rc="$HOME/.zshrc" ;;
    bash)
      if [ -f "$HOME/.bash_profile" ]; then
        shell_rc="$HOME/.bash_profile"
      else
        shell_rc="$HOME/.bashrc"
      fi
      ;;
    fish)
      echo '   fish_add_path ~/.local/bin'
      echo ""
      echo "   Then restart your terminal or run: source ~/.config/fish/config.fish"
      shell_rc=""
      ;;
    *)    shell_rc="$HOME/.profile" ;;
  esac
  if [ -n "$shell_rc" ]; then
    echo "   echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> $shell_rc"
    echo ""
    echo "   Then restart your terminal or run: source $shell_rc"
  fi
  echo ""
fi

echo ""
echo "🎉 LazyClaude is ready!"
echo "   Run 'lazyclaude' in any project directory."
echo ""
echo "   Layout:"
echo "   ┌──────────┬──────────┐"
echo "   │          │ TERMINAL │"
echo "   │  CLAUDE  ├──────────┤"
echo "   │          │ LAZYGIT  │"
echo "   └──────────┴──────────┘"
echo ""
echo "   File explorer: type 'yazi' in terminal"
echo "   Ctrl+b z → Zoom pane"
