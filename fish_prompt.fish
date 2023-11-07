function set_if_undefined
    if not set -q $argv[1]
        set -g $argv[1] $argv[2..-1]
    end
end

function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus

    set_if_undefined __fish_git_prompt_show_informative_status 1
    set_if_undefined __fish_git_prompt_hide_untrackedfiles 1
    set_if_undefined __fish_git_prompt_color_branch magenta --bold
    set_if_undefined __fish_git_prompt_showupstream "informative"
    set_if_undefined __fish_git_prompt_char_upstream_ahead "↑"
    set_if_undefined __fish_git_prompt_char_upstream_behind "↓"
    set_if_undefined __fish_git_prompt_char_upstream_prefix ""
    set_if_undefined __fish_git_prompt_char_stagedstate "●"
    set_if_undefined __fish_git_prompt_char_dirtystate "✚"
    set_if_undefined __fish_git_prompt_char_untrackedfiles "…"
    set_if_undefined __fish_git_prompt_char_invalidstate "✖"
    set_if_undefined __fish_git_prompt_char_cleanstate "✔"
    set_if_undefined __fish_git_prompt_color_dirtystate blue
    set_if_undefined __fish_git_prompt_color_stagedstate yellow
    set_if_undefined __fish_git_prompt_color_invalidstate red
    set_if_undefined __fish_git_prompt_color_untrackedfiles $fish_color_normal
    set_if_undefined __fish_git_prompt_color_cleanstate green --bold

    set_if_undefined __fish_git_prompt_color 999
    set_if_undefined __fish_git_prompt_color_upstream normal
    set_if_undefined __fish_git_prompt_color_downstream normal

    set -l color_cwd
    set -l suffix
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '$'
    end

    set_color $color_cwd
    echo -n (prompt_pwd)
    set_color normal

    printf '%s ' (fish_git_prompt | string replace '(' '[' | string replace ')' ']')
    set -l pipestatus_string (__fish_print_pipestatus "[" "] " "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus)
    echo -n $pipestatus_string

    set_color yellow
    echo -n "$suffix "
end
