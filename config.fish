# env
set -gx LANG en_US.UTF-8
set -gx LC_NUMERIC en_US.UTF-8
set -gx EDITOR nvim
set -gx PAGER less
set -gx XDG_CONFIG_HOME ~/.config

# telemetry optout
set -gx DO_NOT_TRACK 1  # https://consoledonottrack.com/
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx POWERSHELL_TELEMETRY_OPTOUT 1
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx STNOUPGRADE 1   # syncthing
set -gx AZURE_CORE_COLLECT_TELEMETRY 0
set -gx STRIPE_CLI_TELEMETRY_OPTOUT 1

# abbriviation
abbr -a -- rm trash
abbr -a -- mv 'mv -i'
abbr -a -- cp 'cp -i'
abbr -a -- mkdir 'mkdir -p'
abbr -a -- vim nvim
abbr -a -- j z
abbr -a -- cht cht.sh
abbr -a -- btc 'curl rate.sx'
abbr -a -- kg 'kubectl get'
abbr -a -- kdp 'kubectl describe pod'

# set fish_complete_path
set -a fish_complete_path ~/.config/fish/completions/fish-completions-bio/completions ~/.config/fish/completions/fish-completions-extra/completions

# local bin
fish_add_path ~/.local/bin
fish_add_path ~/bin

# disable welcome message
set -g fish_greeting

# cht.sh
set -gx CHTSH $XDG_CONFIG_HOME/cht.sh

# zoxide
if type -q zoxide
    zoxide init fish | source
end

# source-highlight in less
set -gx HIGHLIGHT '/usr/share/source-highlight'
set -gx LESSOPEN "| $HIGHLIGHT/src-hilite-lesspipe-bio.sh %s"
set -gx LESS ' -R '

# colorful man
# ported from ~/.less_termcap
set -x LESS_TERMCAP_mb (tput bold; tput setaf 2) # green
set -x LESS_TERMCAP_md (printf "\e[1;31m")
set -x LESS_TERMCAP_me (tput sgr0)
set -x LESS_TERMCAP_so (printf "\e[1;44;33m")
set -x LESS_TERMCAP_se (tput rmso; tput sgr0)
set -x LESS_TERMCAP_us (printf "\e[1;32m")
set -x LESS_TERMCAP_ue (tput rmul; tput sgr0)
set -x LESS_TERMCAP_mr (tput rev)
set -x LESS_TERMCAP_mh (tput dim)
set -x LESS_TERMCAP_ZN (tput ssubm)
set -x LESS_TERMCAP_ZV (tput rsubm)
set -x LESS_TERMCAP_ZO (tput ssupm)
set -x LESS_TERMCAP_ZW (tput rsupm)
set -x GROFF_NO_SGR 1         # For Konsole and Gnome-terminal

# kitty
if [ "$TERM" = "xterm-kitty" ] && type -q kitty
    alias icat="kitty +kitten icat"
end


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/miniforge3/bin/conda
    eval /opt/miniforge3/bin/conda "shell.fish" "hook" $argv | source
end

if test -f "/opt/miniforge3/etc/fish/conf.d/mamba.fish"
    source "/opt/miniforge3/etc/fish/conf.d/mamba.fish"
end
# <<< conda initialize <<<

