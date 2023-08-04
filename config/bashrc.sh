#!/usr/bin/env bash
# shellcheck disable=SC2139 # That's exactly the behaviour I want
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ XDG ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ The usual ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
export LC_ALL="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Paths ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
eval "$(/opt/homebrew/bin/brew shellenv bash)"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin${PATH:+:$PATH}"
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
default_exa="exa --group-directories-first --group --icons --header --git"
alias f="nvim"
alias ls="$default_exa"
alias ll="$default_exa --long"
alias la="$default_exa --long --all"
alias tree="$default_exa --tree"
alias bathelp="bat --plain --language=help"
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Prompt ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
gitprompt() {
  # Thanks GPT TODO understand hehe
  if [ -d .git ] || git rev-parse --git-dir >/dev/null 2>&1; then
    repo_name=$(basename "$(git rev-parse --show-toplevel)")
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -z "$branch" ]; then
      branch=$(git rev-parse --short HEAD 2>/dev/null)
    fi
    echo "  ~  $repo_name/$branch"
  else
    echo ""
  fi
}
PS1='\n$PWD$(gitprompt)\n'
PS2='│'
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ External bloat ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# Read ripgrep settings
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgreprc"
# Resolve symlinks to get true paths for database
export _ZO_RESOLVE_SYMLINKS="1"
# shellcheck disable=SC1091 # SC sometimes can't follow paths
[ -f ~/.fzf.bash ] && . "$HOME/.fzf.bash"
# Preview file content using bat
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'tree {}'"
# Zoxide init
eval "$(zoxide init bash --cmd j)"
# Conda init
if __conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"; then
  eval "$__conda_setup"
else
  if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
    . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
  else
    export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
  fi
fi
unset __conda_setup
