# vim: set fileencoding=utf-8 ft=zsh

# Utility {{{
__prompt_powerline_set_variables() {
    if [[ "$LANG" =~ "UTF-8$" ]]; then
        # enable powerline like character
        # powerline patched fonts are required
        LSF='⮀'
        LST='⮁'
        RSF='⮂'
        RST='⮃'
        LOCK='⭤'
        BRANCH='⭠'
    else
        LSF=''
        LST='|'
        RSF=''
        RST='|'
        LOCK='*'
        BRANCH='&'
    fi
}
__prompt_powerline_left_segment() {
    if [ ! -n "$1" ]; then
        # ignore this segment
        return
    fi
    echo -en "%{%K{$3}%}$LSF%{%F{$2}%} $1 %{%F{$3}%}"
}
__prompt_powerline_right_segment() {
    if [ ! -n "$1" ]; then
        # ignore this segment
        return
    fi
    echo -en "%{%F{$3}%}$RSF%{%K{$3}%F{$2}%} $1 "
}
# }}}

# Left segments {{{

# userinfo segment {{{
__prompt_powerline_userinfo_segment() {
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
        echo -en "%{%F{$2}%}"
        __prompt_powerline_left_segment "$host $LST $user" $1 $2
    elif [ -n "$host$user" ]; then
        # display hostname or username
        echo -en "%{%F{$2}%}"
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

    # prompt_userinfo {{{
    local userinfo_f userinfo_b
    if [[ $UID -eq 0 ]]; then
        zstyle -s ":prompt:powerline:colors" userinfo-foreground-root \
            userinfo_f || userinfo_f="white"
        zstyle -s ":prompt:powerline:colors" userinfo-background-root \
            userinfo_b || userinfo_b="red"
    elif [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
        zstyle -s ":prompt:powerline:colors" userinfo-foreground-ssh \
            userinfo_f || userinfo_f="black"
        zstyle -s ":prompt:powerline:colors" userinfo-background-ssh \
            userinfo_b || userinfo_b="green"
    else
        zstyle -s ":prompt:powerline:colors" userinfo-foreground \
            userinfo_f || userinfo_f="black"
        zstyle -s ":prompt:powerline:colors" userinfo-background \
            userinfo_b || userinfo_b="blue"
    fi
    local default_username prompt_userinfo
    zstyle -s ":prompt:powerline:userinfo" default-username \
        default_username || default_username=""
    prompt_userinfo=$(__prompt_powerline_userinfo_segment \
        $userinfo_f $userinfo_b $default_username)
    #}}}

    # prompt_precmd {{{
    __prompt_powerline_prompt_precmd() {
        local exitstate=$?
        local LSF LST RSF RST LOCK BRANCH
        __prompt_powerline_set_variables
        __prompt_powerline_prompt_bits=()
        # exit state {{{
        local exitstate_f exitstate_b
        zstyle -s ":prompt:powerline:colors" exitstate-foreground \
            exitstate_f || exitstate_f="white"
        zstyle -s ":prompt:powerline:colors" exitstate-background \
            exitstate_b || exitstate_b="red"
        if [[ $exitstate > 0 ]]; then
            # display only when exitcode is higher than 0
            __prompt_powerline_prompt_bits+=( \
                "$(__prompt_powerline_exitstate_segment $exitstate_f $exitstate_b)")
        fi
        #}}}
        # current directory {{{
        local pwd_f pwd_b
        zstyle -s ":prompt:powerline:colors" pwd-foreground \
            pwd_f || pwd_f="white"
        zstyle -s ":prompt:powerline:colors" pwd-background \
            pwd_b || pwd_b="black"
        __prompt_powerline_prompt_bits+=( \
            "$(__prompt_powerline_pwd_segment $pwd_f $pwd_b)") 
        # }}}
        # linealize
        __prompt_powerline_prompt_bits=${(j::)__prompt_powerline_prompt_bits}
    }
    add-zsh-hook precmd __prompt_powerline_prompt_precmd
    # }}}

    PROMPT="$prompt_userinfo\$__prompt_powerline_prompt_bits%{%k%}$LSF%{%b%f%} "
}
# }}}

# RPROMPT {{{
__prompt_powerline_rprompt() {
    __prompt_powerline_rprompt_precmd() {
        local LSF LST RSF RST LOCK BRANCH
        __prompt_powerline_set_variables
        __prompt_powerline_rprompt_bits=()
        # version control system {{{
        local vcs_f vcs_b
        zstyle -s ":prompt:powerline:colors" vcs-foreground \
            vcs_f || vcs_f="white"
        zstyle -s ":prompt:powerline:colors" vcs-background \
            vcs_b || vcs_b="cyan"
        __prompt_powerline_rprompt_bits+=( \
            "$(__prompt_powerline_vcs_segment $vcs_f $vcs_b)") 
        # }}}
        # date {{{
        local date_f date_b
        zstyle -s ":prompt:powerline:colors" date-foreground \
            date_f || date_f="black"
        zstyle -s ":prompt:powerline:colors" date-background \
            date_b || date_b="yellow"
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

    local LSF LST RSF RST LOCK BRANCH
    __prompt_powerline_set_variables

    __prompt_powerline_vcsstyles
    __prompt_powerline_prompt
    __prompt_powerline_rprompt
}
