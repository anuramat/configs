#!/usr/bin/env sh

# XDG paths
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_PICTURES_DIR="$HOME/Pictures"

export GRIM_DEFAULT_DIR="$HOME/Screenshots"

# User binaries
export PATH="$HOME/bin${PATH:+:$PATH}"

# Locale
export LC_ALL="en_US.UTF-8"

# ls replacement
export EZACMD="eza --group-directories-first --group --icons --header --git --color=always"

# Vim
for editor in nvim vim nvi vi; do
	if command -v "$editor" >/dev/null 2>&1; then
		export VISUAL="$editor"
		break
	fi
done
export EDITOR="$VISUAL"

# Go modules and binaries
export GOPATH="$HOME/go"
export PATH="${PATH:+$PATH:}$GOPATH/bin"

# Node
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"

# __pycache__ folder
export PYTHONPYCACHEPREFIX="/tmp/pycache"
export PYTHONUSERBASE="$XDG_DATA_HOME/python"
# NOTE .pyhistory is still hardcoded: https://github.com/python/cpython/pull/13208

# Homebrew path
export HOMEBREW_PREFIX="/opt/homebrew"
if _brewshellenv="$("$HOMEBREW_PREFIX/bin/brew" shellenv)"; then
	eval "$_brewshellenv"
fi

# Homebrew
export HOMEBREW_NO_ANALYTICS="true"
export HOMEBREW_BUNDLE_NO_LOCK="true"
