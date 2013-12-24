# vim: set fileencoding=utf-8 ft=zsh
# Configure {{{
zstyle ":prompt:powerline:colors" pwd-foreground 16
zstyle ":prompt:powerline:colors" pwd-background 5

zstyle ":prompt:powerline:colors" userinfo-foreground-root 7
zstyle ":prompt:powerline:colors" userinfo-background-root 1
zstyle ":prompt:powerline:colors" userinfo-foreground 8
zstyle ":prompt:powerline:colors" userinfo-background 2

zstyle ":prompt:powerline:userinfo" default-username 'alisue'

zstyle ":prompt:powerline:colors" exitstate-foreground 7
zstyle ":prompt:powerline:colors" exitstate-background 1

zstyle ":prompt:powerline:colors" vcs-foreground 16
zstyle ":prompt:powerline:colors" vcs-background 6

zstyle ":prompt:powerline:colors" date-foreground 16
zstyle ":prompt:powerline:colors" date-background 3

zstyle ":prompt:powerline:colors" mode-foreground 7
zstyle ":prompt:powerline:colors" mode-normal-background 1
zstyle ":prompt:powerline:colors" mode-insert-background 4

if [[ "$LANG" =~ "UTF-8$" ]]; then
    # enable powerline like character
    # powerline patched fonts are required
    zstyle ":prompt:powerline:symbols" left-separator-full '⮀'
    zstyle ":prompt:powerline:symbols" left-separator-thin '⮁'
    zstyle ":prompt:powerline:symbols" right-separator-full '⮂'
    zstyle ":prompt:powerline:symbols" right-separator-thin '⮃'
    zstyle ":prompt:powerline:symbols" lock '⭤'
    zstyle ":prompt:powerline:symbols" branch '⭠'
else
    zstyle ":prompt:powerline:symbols" left-separator-full ''
    zstyle ":prompt:powerline:symbols" left-separator-thin '|'
    zstyle ":prompt:powerline:symbols" right-separator-full ''
    zstyle ":prompt:powerline:symbols" right-separator-thin '|'
    zstyle ":prompt:powerline:symbols" lock '*'
    zstyle ":prompt:powerline:symbols" branch '&'
fi
#}}}

# Utility {{{
__prompt_powerline_left_segment() {
    local LSF
    zstyle -s ":prompt:powerline:symbols" left-separator-full LSF
    if [ ! -n "$1" ]; then
        # ignore this segment
        return
    fi
    echo -en "%{%K{$3}%}$LSF%{%F{$2}%} $1 %{%F{$3}%}"
}
__prompt_powerline_right_segment() {
    local RSF
    zstyle -s ":prompt:powerline:symbols" right-separator-full RSF
    if [ ! -n "$1" ]; then
        # ignore this segment
        return
    fi
    echo -en "%{%F{$3}%}$RSF%{%K{$3}%F{$2}%} $1 "
}
# }}}

# Left segments {{{

# mode segment {{{
__prompt_powerline_vimode_segment() {
    local color name
    case $KEYMAP in
        vicmd)
            name="NORMAL"
            color=$2;;
        main|viins)
            name="INSERT"
            color=$3;;
    esac
    # display mode
    echo -en "%{%F{$color}%}"
    __prompt_powerline_left_segment "$name" $1 $color
}
function __prompt_powerline_update_vimode() {
    local mode_f mode_normal_b mode_insert_b
    zstyle -s ":prompt:powerline:colors" mode-foreground mode_f
    zstyle -s ":prompt:powerline:colors" mode-normal-background mode_normal_b
    zstyle -s ":prompt:powerline:colors" mode-insert-background mode_insert_b
    __prompt_powerline_prompt_prefix="$(__prompt_powerline_vimode_segment $mode_f $mode_normal_b $mode_insert_b)"
}
function zle-line-init zle-keymap-select {
    __prompt_powerline_update_vimode
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
# }}}

# userinfo segment {{{
__prompt_powerline_userinfo_segment() {
    local LST
    zstyle -s ":prompt:powerline:symbols" left-separator-thin LST
    local host
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
        # show hostname only when user is connected to remote machine
        # %m -- short machine name
        host="%m"
    fi
    local user
    if [[ "$USER" != "$3" ]]; then
        # show username only when username is different from default
        # %n -- user name
        user="%n"
    fi
    # display userinfo
    if [ -n "$host" -a -n "$user" ]; then
        # display hostname and username
        __prompt_powerline_left_segment "$host $LST $user" $1 $2
    elif [ -n "$host$user" ]; then
        # display hostname or username
        __prompt_powerline_left_segment "$host$user" $1 $2
    fi
}
# }}}

# exitstate segment {{{
__prompt_powerline_exitstate_segment() {
    __prompt_powerline_left_segment "%?" $1 $2
}
#}}}

# pwd segment {{{
__prompt_powerline_pwd_segment() {
    local LOCK
    zstyle -s ":prompt:powerline:symbols" lock LOCK
    # current path state
    local pwd_state
    if [[ ! -O $PWD ]]; then
        if [[ -w $PWD ]]; then
            pwd_state="%{%F{blue}%}$LOCK "
        elif [[ -x $PWD ]]; then
            pwd_state="%{%F{yellow}%}$LOCK "
        elif [[ -r $PWD ]]; then
            pwd_state="%{%F{red}%}$LOCK "
        fi
    fi
    if [[ ! -w $PWD && ! -r $PWD ]]; then
        pwd_state="%{%F{red}%}$LOCK "
    fi
    # current path truncate over 40 chars
    local pwd_path="%39<...<%~"
    __prompt_powerline_left_segment "$pwd_state$pwd_path" $1 $2
}
# }}}

# }}}

# Right segments {{{

# date segment {{{
__prompt_powerline_date_segment() {
    local prompt_date="%D{%H:%M:%S}"    # Datetime YYYY/mm/dd HH:MM
    __prompt_powerline_right_segment "$prompt_date" $1 $2
}
# }}}

# vcs segment {{{
__prompt_powerline_vcs_segment() {
    vcs_info 'powerline'
    if [[ -n "$vcs_info_msg_0_" ]]; then
        __prompt_powerline_right_segment "$vcs_info_msg_0_" $1 $2
    fi
}
# }}}

# }}}

# PROMPT {{{
__prompt_powerline_prompt() {
    # update vimode segment
    __prompt_powerline_update_vimode

    # prompt_userinfo {{{
    local userinfo_f userinfo_b
    if [[ $UID -eq 0 ]]; then
        zstyle -s ":prompt:powerline:colors" userinfo-foreground-root userinfo_f
        zstyle -s ":prompt:powerline:colors" userinfo-background-root userinfo_b
    else
        zstyle -s ":prompt:powerline:colors" userinfo-foreground userinfo_f
        zstyle -s ":prompt:powerline:colors" userinfo-background userinfo_b
    fi
    local default_username prompt_userinfo
    zstyle -s ":prompt:powerline:userinfo" default-username default_username
    prompt_userinfo=$(__prompt_powerline_userinfo_segment \
        $userinfo_f $userinfo_b $default_username)
    #}}}

    # prompt_precmd {{{
    __prompt_powerline_prompt_precmd() {
        local exitstate=$?
        __prompt_powerline_prompt_bits=()
        # exit state {{{
        local exitstate_f exitstate_b
        zstyle -s ":prompt:powerline:colors" exitstate-foreground exitstate_f
        zstyle -s ":prompt:powerline:colors" exitstate-background exitstate_b
        if [[ $exitstate > 0 ]]; then
            # display only when exitcode is higher than 0
            __prompt_powerline_prompt_bits+=( \
                "$(__prompt_powerline_exitstate_segment $exitstate_f $exitstate_b)")
        fi
        #}}}
        # current directory {{{
        local pwd_f pwd_b
        zstyle -s ":prompt:powerline:colors" pwd-foreground pwd_f
        zstyle -s ":prompt:powerline:colors" pwd-background pwd_b
        __prompt_powerline_prompt_bits+=( \
            "$(__prompt_powerline_pwd_segment $pwd_f $pwd_b)") 
        # }}}
        # linealize
        __prompt_powerline_prompt_bits=${(j::)__prompt_powerline_prompt_bits}
    }
    add-zsh-hook precmd __prompt_powerline_prompt_precmd
    # }}}
    local LSF
    zstyle -s ":prompt:powerline:symbols" left-separator-full LSF
    PROMPT="\$__prompt_powerline_prompt_prefix$prompt_userinfo\$__prompt_powerline_prompt_bits%{%k%}$LSF%{%b%f%} "
}
# }}}

# RPROMPT {{{
__prompt_powerline_rprompt() {
    __prompt_powerline_rprompt_precmd() {
        __prompt_powerline_rprompt_bits=()
        # version control system {{{
        local vcs_f vcs_b
        zstyle -s ":prompt:powerline:colors" vcs-foreground vcs_f
        zstyle -s ":prompt:powerline:colors" vcs-background vcs_b
        __prompt_powerline_rprompt_bits+=( \
            "$(__prompt_powerline_vcs_segment $vcs_f $vcs_b)") 
        # }}}
        # date {{{
        local date_f date_b
        zstyle -s ":prompt:powerline:colors" date-foreground date_f
        zstyle -s ":prompt:powerline:colors" date-background date_b
        __prompt_powerline_rprompt_bits+=( \
            "$(__prompt_powerline_date_segment $date_f $date_b)") 
        #}}}
        # linealize
        __prompt_powerline_rprompt_bits=${(j::)__prompt_powerline_rprompt_bits}
    }
    add-zsh-hook precmd __prompt_powerline_rprompt_precmd
    RPROMPT="\$__prompt_powerline_rprompt_bits%{%k%b%f%}"
}
# }}}

# VCS style {{{
function __prompt_powerline_vcsstyles() {
    local BRANCH
    zstyle -s ":prompt:powerline:symbols" branch BRANCH
    local branchfmt="$BRANCH %b:%r%u%c"
    local actionfmt="%a%f"
    autoload -Uz is-at-least
    if is-at-least 4.3.10; then
        autoload -Uz vcs_info
        zstyle ':vcs_info:*:powerline:*' formats "$branchfmt(%s)"
        zstyle ':vcs_info:*:powerline:*' actionformats "$branchfmt$actionfmt(%s)"
        # I mainly use git so do not show vcs type
        zstyle ':vcs_info:git:powerline:*' formats "$branchfmt"
        zstyle ':vcs_info:git:powerline:*' actionformats "$branchfmt$actionfmt"
        # enable check for changes
        zstyle ':vcs_info:git:powerline:*' check-for-changes true
        zstyle ':vcs_info:git:powerline:*' unstagedstr '[u]' 
        zstyle ':vcs_info:git:powerline:*' stagedstr '[s]'
    fi
}
# }}}

function() {
    # enable variable extraction in prompt
    setopt prompt_subst
    __prompt_powerline_vcsstyles
    __prompt_powerline_prompt
    __prompt_powerline_rprompt
}

