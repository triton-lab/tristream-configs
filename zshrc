# shellcheck disable=SC2148
# shellcheck disable=SC2034

## =======================================
##            Alias Commands
## =======================================
alias ls="ls --color"
alias la='ls -A'
alias ll='ls -alFh'

alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"
alias mkdir="mkdir -p"

[[ "$(command -v nvim)" ]] && alias vim=nvim


## =======================================
##             ZSH config
## =======================================

## Checkmarked [✓] settings are from .zshrc by naoya@Hatena.

## Completion
##  Examples: Type "ls -" then press TAB
##            Type "tar " then press TAB
autoload -Uz compinit; compinit

## Use color [✓]
setopt prompt_subst

## copied from https://github.com/Phantas0s/.dotfiles/blob/master/zsh/zshrc
setopt extended_history          # Write the history file in the ':start:elapsed;command' format.
setopt share_history             # Share history between all sessions.
setopt hist_expire_dups_first    # Expire a duplicate event first when trimming history.
setopt hist_ignore_dups          # Do not record an event that was just recorded again.
setopt hist_ignore_all_dups      # Delete an old recorded event if a new event is a duplicate.
setopt hist_find_no_dups         # Do not display a previously found event.
setopt hist_ignore_space         # Do not record an event starting with a space.
setopt hist_save_no_dups         # Do not write a duplicate event to the history file.
setopt hist_verify               # Do not execute immediately upon history expansion.

## Keyboad config ... emacs-like key binding (such as C-f, C-b)
bindkey -e

## Correct command [✓]
setopt correct

## Show file types in completion list [✓]
setopt list_types

## Disable beep [✓]
setopt nobeep

## Display list automatically [✓]
setopt auto_list

## Show recently-visited folders when "cd -" and TAB [✓]
setopt auto_pushd

## Remove duplicates in the auto_pushd list
setopt pushd_ignore_dups

## Browse history backward/forward by Ctl-p/Ctl-n
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

## Use #, ~, ^ as regular expression symbols for file names [✓]
setopt extended_glob

## Switch options by TAB [✓]
setopt auto_menu

## Change directory without typing cd [✓]
setopt auto_cd

## Close parenthesis automatically [✓]
setopt auto_param_keys

## Add / (slash) automatically after a directory name [✓]
setopt auto_param_slash

## Predict entry
# autoload predict-on
# predict-on

## Expand aliases before completing
setopt complete_aliases # aliased ls needs if file/dir completions work

## Bash-like comment in command line
## See https://stackoverflow.com/questions/11670935/comments-in-command-line-zsh
setopt interactivecomments

## ctrl+u works like bash/readline
## https://stackoverflow.com/questions/3483604/which-shortcut-in-zsh-does-the-same-as-ctrl-u-in-bash
bindkey "^U" backward-kill-line


## =======================================
##     Prompt Configurations
## =======================================

## Use colors in prompt
autoload colors && colors

## StackOverflow mentions that zsh comes with builtin colored prompt themes
## Type command "prompt -p adam1" for example.
autoload -U promptinit && promptinit

## zsh-syntax-highlighting
if [[ "$(uname -s)" == "Darwin" ]]; then
    # following homebrew package instruction
    # https://formulae.brew.sh/formula/zsh-syntax-highlighting
    source "$(brew --prefix)"/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

## zsh-autosuggestions
if [[ "$(uname -s)" == "Darwin" ]]; then
    # following homebrew package instruction
    # https://formulae.brew.sh/formula/zsh-autosuggestions
    source "$(brew --prefix)"/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
## color sheme: https://coderwall.com/p/pb1uzq/z-shell-colors
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'

## zsh-git-prompt
## https://github.com/zsh-git-prompt/zsh-git-prompt
source ~/.config/zsh/zsh-git-prompt/zshrc.sh
ZSH_THEME_GIT_PROMPT_PREFIX="%F{246}[%F{reset_color}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{246}]%F{reset_color} "
ZSH_THEME_GIT_PROMPT_SEPARATOR="%F{246}|%F{reset_color}"

## Custom Prompt
PROMPT='${SSH_TTY:+"%F{green}%n%F{yellow}@%F{green}%m%F{reset_color} "}%F{green}%~%F{reset_color} $(git_super_status)%F{yellow}$%F{reset_color} '

## Colors on completion suggestions
## https://stackoverflow.com/questions/23152157/how-does-the-zsh-list-colors-syntax-work
##
## 256 color palette
## 1;38;5;142  ... 256 color palette (142 )  # https://www.ditig.com/256-colors-cheat-sheet
##
## CLI_COLOR
##  0 ... default
## 30 ... black
## 31 ... red      91 ... light red
## 32 ... green    92 ... light green
## 33 ... yellow   93 ... light yellow
## 34 ... blue     94 ... light blue
## 35 ... magenta  95 ... light magenta
## 36 ... cyan     96 ... light cyan
## 37 ... white
## 41   ... red (background)
## 1;31 ... red (bold)
##
zstyle ':completion:*' list-colors '=(#b)*(--)( *)=37=1;38;5;103=1;38;5;142' '=*=0'

## source-highlight in less
export LESSOPEN="| /usr/bin/lesspipe.sh %s"
export LESS=" -R "

## colorful man
# shellcheck source=~/.less_termcap
[[ -e ~/.less_termcap ]] && source ~/.less_termcap

## fzf
# shellcheck source=~/.fzf.zsh
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# zoxide
[[ "$(command -v zoxide)" ]] && eval "$(zoxide init zsh)"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/opt/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/opt/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<


# Hide (base) in prompt at startup
PS1="$(echo "$PS1" | sed 's/(base) //')"


# cd to ~/MyFiles/HomeFolder as its the persistent home folder
if [[ -d "$HOME/MyFiles/HomeFolder" ]]; then
    owner=$(stat -c '%U' "$HOME/MyFiles/HomeFolder/")
    if [ "$owner" = "as2-streaming-user" ]; then
        cd "$HOME/MyFiles/HomeFolder" || return
    fi
fi
