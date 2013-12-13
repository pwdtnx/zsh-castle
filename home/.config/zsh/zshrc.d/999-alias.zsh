# homeshick
if [[ -d "$HOME/.homesick/repos/homeshick" ]]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    # if homesick is not installed, add alias
    if ! type homesick > /dev/null 2>&1; then
        alias homesick="homeshick"
    fi
fi

# hub
if type hub > /dev/null 2>&1; then
    alias git="hub"
fi

# anyenv
if [[ -d "$HOME/.anyenv/bin" ]]; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init - zsh)"
fi

# Load local configures
[[ -f ~/.profile ]] && source ~/.profile
