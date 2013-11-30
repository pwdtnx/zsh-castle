# vim: set fileencoding=utf-8 ft=zsh

# Utility {{{
__prompt_powerline_left_segment() {
    if [ ! -n "$1" ]; then
        return 0
    fi
    echo -en "%{%K{$3}%}$LSF%{%F{$2}%} $1 %{%F{$3}%}"
}
__prompt_powerline_right_segment() {
    if [ ! -n "$1" ]; then
        return 0
    fi
    echo -en "%{%F{$3}%}$RSF%{%K{$3}%F{$2}%} $1 "
}
# }}}

# Left segments {{{
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
    return 0
}
__prompt_powerline_exitstate_segment() {
    __prompt_powerline_left_segment "%?" $1 $2
    return 0
}
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
    return 0
}
# }}}

# Right segments {{{
__prompt_powerline_date_segment() {
    local prompt_date="%D{%H:%M:%S}"    # Datetime YYYY/mm/dd HH:MM
    __prompt_powerline_right_segment "$prompt_date" $1 $2
    return 0
}
__prompt_powerline_vcs_segment() {
}
# }}}

__prompt_powerline_prompt() {
    local prompt_userinfo
    if [[ $UID -eq 0 ]]; then
        # change color when the user is root
        prompt_userinfo=$(__prompt_powerline_userinfo_segment white red "")
    elif [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
        # change color when the user connect to remote machine
        prompt_userinfo=$(__prompt_powerline_userinfo_segment black green "")
    else
        prompt_userinfo=$(__prompt_powerline_userinfo_segment black blue "")
    fi
    __prompt_powerline_prompt_precmd() {
        LANG=en_US.UTF-8
        vcs_info 'powerline'
        local exitstate=$?
        local LSF='⮀'
        local LST='⮁'
        local RSF='⮂'
        local RST='⮃'
        local LOCK='⭤'
        __prompt_powerline_prompt_bits=()
        __prompt_powerline_rprompt_bits=()
        if [[ "$exitstate" != "0" ]]; then
            echo "exitstate: $exitstate"
            # display only when exitcode is higher than 0
            __prompt_powerline_prompt_bits+=( \
                "$(__prompt_powerline_exitstate_segment white red $exitstate)")
        fi
        __prompt_powerline_prompt_bits+=( \
            "$(__prompt_powerline_pwd_segment white black)") 
        if [[ -n "$vcs_info_msg_0_" ]]; then
            __prompt_powerline_rprompt_bits+=( \
                "$(__prompt_powerline_right_segment $vcs_info_msg_0_ white cyan)") 
        fi
        __prompt_powerline_rprompt_bits+=( \
            "$(__prompt_powerline_date_segment black yellow)") 
        __prompt_powerline_prompt_bits=${(j::)__prompt_powerline_prompt_bits}
        __prompt_powerline_rprompt_bits=${(j::)__prompt_powerline_rprompt_bits}
        return 0
    }
    add-zsh-hook precmd __prompt_powerline_prompt_precmd
    PROMPT="$prompt_userinfo\$__prompt_powerline_prompt_bits%{%k%}$LSF%{%b%f%} "
    RPROMPT="\$__prompt_powerline_rprompt_bits%{%k%b%f%}"
    return 0
}

# VCS style {{{
function __prompt_powerline_vcsstyles() {
    local branchfmt="$BRANCH %b%u%c"
    local actionfmt="%a%f"
    local git="±"
    local hg="☿"
    autoload -Uz is-at-least
    if is-at-least 4.3.10; then
        autoload -Uz vcs_info
        zstyle ':vcs_info:*:powerline:*' unstagedstr '¹' 
        zstyle ':vcs_info:*:powerline:*' stagedstr '²'
        zstyle ':vcs_info:*:powerline:*' formats "$branchfmt(%s)"
        zstyle ':vcs_info:*:powerline:*' actionformats "$branchfmt$actionfmt(%s)"
        zstyle ':vcs_info:git:powerline:*' formats "$branchfmt"
        zstyle ':vcs_info:git:powerline:*' actionformats "$branchfmt$actionfmt"
        zstyle ':vcs_info:hg:powerline:*' formats "$branchfmt($hg)"
        zstyle ':vcs_info:hg:powerline:*' actionformats "$branchfmt$actionfmt($hg)"
    fi
}
# }}}

function() {
    local LSF='⮀'
    local LST='⮁'
    local RSF='⮂'
    local RST='⮃'
    local LOCK='⭤'
    local BRANCH='⭠'

    __prompt_powerline_vcsstyles
    __prompt_powerline_prompt
}
