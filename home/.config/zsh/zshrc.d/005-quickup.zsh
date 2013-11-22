# cd up with ^^
cdup() {
    if [ -z "$BUFFER" ]; then
        echo
        cd ../
        if type precmd > /dev/null 2>&1; then
            precmd
        fi
        local precmd_func
        for precmd_func in $precmd_functions; do
            $precmd_func
        done
        zle reset-prompt
    else
        zle self-insert '^^'
    fi
}
zle -N cdup
bindkey '\^\^' cdup

# popd up with [[
function call_popd() {
    if [ -z "$BUFFER" ]; then
        echo
        popd
        if type precmd > /dev/null 2>&1; then
            precmd
        fi
        local precmd_func
        for precmd_func in $precmd_functions; do
            $precmd_func
        done
        zle reset-prompt
    else
        zle self-insert '[['
    fi
}
zle -N call_popd
bindkey '[[' call_popd
