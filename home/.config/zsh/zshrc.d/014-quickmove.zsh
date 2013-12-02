# cd up with ^^
cdup() {
    if [ -z "$BUFFER" ]; then
        echo
        cd ../
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
        zle reset-prompt
    else
        zle self-insert '[['
    fi
}
zle -N call_popd
bindkey '[[' call_popd
