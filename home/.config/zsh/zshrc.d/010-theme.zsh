# Load colors to use color as $fg[red] or whatever
autoload -Uz colors && colors

setopt prompt_subst         # Enable expand variable, subset command, mathmatical operation
                            # in PROMPT
setopt prompt_percent       # Enable replacement string which starts with %
unsetopt transient_rprompt  # Show RPROMPT even after command run

# variables used in prompt
newline=$'\n'
prompt_user="`whoami`"                                  # Current user name
prompt_host="$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]')"  # Current host name
prompt_date="%D{%H:%M:%S}"                              # Datetime YYYY/mm/dd HH:MM
prompt_path="%39<...<%~"                                # Current path. truncate over 40 chars
prompt_identify="[$prompt_user@$prompt_host]"           # Username and Hostname
prompt_exitcode="%0(?||%18(?||%{$fg[red]%}))(%?)%{$reset_color%}"           # Previous exit code. 18 is suspended thus ignore
prompt_prefix="%0(?||%18(?||%{$fg[red]%}))%#%{$reset_color%}"

case ${UID} in
0)
    # root. Red
    PROMPT="%{$fg[red]%}$prompt_identify%{$reset_color%}|%~$prompt_prefix "
    PROMPT2="%# "
    RPROMPT2="%{$fg[green]%}%_%{$reset_color%}"
    SPROMPT="%{$fg[red]%}%r is correct? [n,y,a,e]:%{$reset_color%} "
    ;;
*)
    # mine. Blue
    PROMPT="$newline%{$fg[blue]%}$prompt_identify %{$fg[yellow]%}$prompt_date%{$reset_color%}$prompt_exitcode $prompt_path $newline$prompt_prefix "
    PROMPT2="%# "
    RPROMPT2="%{$fg[green]%}%_%{$reset_color%}"
    SPROMPT="%{$fg[blue]%}%r is correct? [n,y,a,e]:%{$reset_color%} "
    # is the terminal connected with SSH?
    if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
        # outside. Green + Bold
        PROMPT="$newline%{$fg_bold[green]%}$prompt_identify %{$fg_no_bold[yellow]%}$prompt_date%{$reset_color%}$prompt_exitcode $prompt_path $newline$prompt_prefix "
    fi
    ;;
esac


# Enable version control info in PROMPT {{{
#
autoload -Uz is-at-least
if is-at-least 4.3.10; then
    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git svn hg bzr
    zstyle ':vcs_info:git:*' formats '%b (%s)'
    zstyle ':vcs_info:git:*' actionformats '%b|%a (%s)'
    zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
    zstyle ':vcs_info:bzr:*' use-simple true

    autoload -Uz is-at-least
    if is-at-least 4.3.10; then
        zstyle ':vcs_info:git:*' check-for-changes true
        zstyle ':vcs_info:git:*' stagedstr "+"
        zstyle ':vcs_info:git:*' unstagedstr "-"
        zstyle ':vcs_info:git:*' formats '%c%u %b (%s)'
        zstyle ':vcs_info:git:*' actionformats '%c%u %b|%a (%s)'
    fi

    function _update_vcs_info_msg() {
        psvar=()
        LANG=en_US.UTF-8 vcs_info
        [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    }
    add-zsh-hook precmd _update_vcs_info_msg
    RPROMPT="%1(v|%{$fg[green]%}%1v%{$reset_color%}|)"
fi
#}}}
