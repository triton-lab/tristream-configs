# /etc/profile.d/conda.sh

# ----------------------------------------------------------------
# Put this in /etc/profile.d/conda.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
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


# For pipx and condax
export PATH="/opt/bin:$PATH"
