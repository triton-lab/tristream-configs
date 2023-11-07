## =======================================
##             ENV variables
## =======================================
export LANG=en_US.UTF-8
export EDITOR=nvim
export PAGER=less
export SHELL=zsh
export LC_NUMERIC=en_US.UTF-8

# XDG
[[ "$(uname -s)" == "Linux" ]] && export XDG_CONFIG_HOME="$HOME/.config"

# zsh fpath
fpath=( ~/.config/zsh/completions ~/.config/zsh/zsh-completions-bio/completions ~/.config/zsh/zsh-completions-extra/completions "${fpath[@]}" )

# zsh history
export HISTFILE=~/.zsh_history
export HISTSIZE=80000
export SAVEHIST=80000

# zsh syntax highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[alias]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

# conda-zsh-completion
fpath+=( $HOME/miniconda3/share/zsh/conda-zsh-completion "${fpath[@]}" )

## local bin
export PATH="$HOME/.local/bin:$PATH"

## rust and cargo
if [[ "$(command -v cargo)" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
    export RUST_BACKTRACE=1
    . "$HOME/.cargo/env"
fi

## go
[[ "$(command -v go)" ]] && export PATH="$PATH:$(go env GOPATH)/bin"


