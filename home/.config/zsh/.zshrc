# disable promptcr to display last line without newline
unsetopt promptcr

# print character as eight bit to prevent mojibake
setopt print_eight_bit

# use ASCII in linux server
if [[ "${TERM}" = "linux" ]]; then
    LANG=C
fi
if [[ ${UID} -eq 0 ]]; then 
    LANG=C
fi

# report time when the process takes over 3 seconds
REPORTTIME=3

# enable completion in --prefix=~/local or whatever
setopt magic_equal_subst

# Movement {{{
WORDCHARS=${WORDCHARS:s,/,,} # Exclude / so you can delete path with ^W
setopt auto_cd               # Automatically change directory when path has input
setopt auto_pushd            # Automatically push previous directory to stack
                             # thus you can pop previous directory with `popd` command
                             # or select from list with `cd <tab>`
setopt pushd_ignore_dups     # Ignore duplicate directory in pushd
#}}}

# History {{{
HISTFILE=${ZDOTDIR}/.zsh_history
HISTSIZE=10000000
SAVEHIST=$HISTSIZE
setopt extended_history      # save execution time and span in history
setopt hist_ignore_all_dups  # ignore duplicate history
setopt hist_ignore_dups      # ignore previous duplicate history
setopt hist_save_no_dups     # remove old one when duplicated
setopt hist_ignore_space     # ignore commands which stars with space
setopt inc_append_history    # immidiately append history to history file
setopt share_history         # share history in zsh processes
setopt no_flow_control       # do not use C-s/C-q
#}}}

# Completion {{{
autoload -Uz compinit && compinit -u

setopt complete_in_word      # complete at carret position
setopt glob_complete         # complete without expanding glob
setopt hist_expand           # expand history when complete
setopt correct               # show suggestion list when user type wrong command
setopt list_packed           # show completion list smaller (pack)
setopt nolistbeep            # stop beep.
setopt noautoremoveslash     # do not remove postfix slash of command line

# ambiguous completion search when no match found
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'

# allow to select suggestions with arrow keys
zstyle ':completion:*:default' menu select

# color completion list
zstyle ':completion:*:default' list-colors ''

# add SUDO_PATH to completion in sudo
zstyle ':completion:*:sudo:*' environ PATH="$SUDO_PATH:$PATH"

# bold the completion list item
zstyle ':completion:*' format "%{$fg[blue]%}--- %d ---%f"

# group completion list
zstyle ':completion:*' group-name ''

# use cache
zstyle ':completion:*' use-cache yes

# use detailed completion
zstyle ':completion:*' verbose yes
# how to find the completion list?
# - _complete:      complete
# - _oldlist:       complete from previous result
# - _match:         complete from the suggestin without expand glob
# - _history:       complete from history
# - _ignored:       complete from ignored
# - _approximate:   complete from approximate suggestions
# - _prefix:        complete without caring the characters after carret
zstyle ':completion:*' completer _oldlist _complete \
    _match _history _ignored _approximate _prefix _j
#}}}

# ls/ps {{{
# - ls:     use GNU ls when available.
# - ps:     display processes related to the user
case $(uname) in
    *BSD|Darwin)
        if [ -x "$(which gnuls)" ]; then
            alias ls="gnuls --color=auto"
            alias la="ls -lhAF"
        else
            alias ls="ls -G -w"
            alias la="ls -lhAFG"
        fi
        alias ps="ps -fU$(whoami)"
        ;;
    SunOS)
        if [ -x "`which gls`" ]; then
            alias ls="gls --color=auto"
            alias la="ls -lhAF"
        fi
        alias ps="ps -fl -u$(/usr/xpg4/bin/id -un)"
        ;;
    *)
        alias ls="ls --color=auto"
        alias la="ls -lhAF"
        alias ps="ps -fU$(whoami) --forest"
        ;;
esac
#}}}

# Key mappings {{{
bindkey -v

# create a zkbd compatible hash
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
function zle-line-init () {
    echoti smkx > /dev/null 2>&1
}
function zle-line-finish () {
    echoti rmkx > /dev/null 2>&1
}
zle -N zle-line-init
zle -N zle-line-finish  


# cycle history with C-p/C-n
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# select completion menu with hjkl
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# I want to delete char with Backspace key in command mode as well
bindkey -M vicmd "^?" vi-backward-delete-char

# Don't use vi mode in backward delete word/char
# because it cannot delete charcters before the position entering insert mode
zle -A .backward-kill-word vi-backward-kill-word
zle -A .backward-delete-char vi-backward-delete-char
# }}}

# Load extra settings and plugins {{{
for filename in ${ZDOTDIR}/zshrc.d/*.zsh; do
    source ${filename}
done

_Z_CMD=j
_Z_DATA=$ZDOTDIR/.z
Bundle rupa/z
Bundle zsh-users/zsh-syntax-highlighting
Bundle zsh-users/zsh-completions
##}}}

# LS_COLORS {{{
Bundle seebi/dircolors-solarized
export LS_COLORS
DIRCOLORS="${ZDOTDIR}/bundle/dircolors-solarized/dircolors.ansi-dark"
if type dircolors > /dev/null 2>&1; then
    eval $(dircolors ${DIRCOLORS})
elif type gdircolors > /dev/null 2>&1; then
    eval $(gdircolors ${DIRCOLORS})
fi
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
#}}}
