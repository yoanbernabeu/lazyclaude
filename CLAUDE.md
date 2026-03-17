# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LazyClaude is a bash-based tmux workspace that combines Claude Code + LazyGit/Yazi + Terminal in a 3-pane layout. Designed for macOS with Homebrew dependencies. Supports **iTerm2 tmux CC mode** for native window integration (auto-detected). No build system, no tests, no linting — just shell scripts and config files.

## Architecture

- `lazyclaude` — Main entrypoint script (bash). Creates a tmux session named `lazyclaude-<dirname>` with 3 panes: Claude Code (left, 60%), Terminal (top-right), LazyGit (bottom-right). Auto-detects iTerm2 and uses `tmux -CC` for native integration. Supports `--cc` / `--no-cc` flags. Handles multi-session management (attach/new/kill).
- `install.sh` — One-line installer. Downloads files from GitHub, places them in `~/.local/bin/`, `~/.tmux.conf`, `~/.config/lazygit/config.yml`, `~/.config/yazi/yazi.toml`. Checks for missing dependencies.
- `tmux.conf` — tmux config: mouse support, green active pane indicator, heavy borders, status bar (session name + git branch). In CC mode, iTerm2 handles UI — these settings are only active in classic mode.
- `lazygit.yml` — LazyGit config: hides file tree, random tips, and command log for a clean UI.
- `yazi.toml` — Yazi config: shows hidden files, removes parent panel (`ratio = [0, 1, 1]`), uses `micro` as editor.

## Key Conventions

- All scripts use `#!/bin/bash` with `set -e` in install.sh
- Session naming convention: `lazyclaude-<basename of current directory>`
- iTerm2 detected via `$TERM_PROGRAM == "iTerm.app"` → auto-enables CC mode
- Session setup is done detached (`new-session -d`) then attached — required for CC mode compatibility
- The install script overwrites config files without confirmation — this is intentional and documented
- Dependencies: tmux, claude (Claude Code CLI), lazygit, yazi, micro
