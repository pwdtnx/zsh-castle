# cd up with ^^
cdup() {
    echo
    cd ..
    zle reset-prompt
}
zle -N cdup
bindkey '\^\^' cdup

# popd up with [[
function call_popd() {
    echo
    popd
    zle reset-prompt
}
zle -N call_popd
bindkey '[[' call_popd
