do_enter() {
    if [ -z "$BUFFER" ]; then
        echo
        ls_abbrev
        zle reset-prompt
    else
        zle accept-line
    fi
}
zle -N do_enter
bindkey '^m' do_enter
