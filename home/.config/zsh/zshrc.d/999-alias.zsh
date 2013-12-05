# homeshick
if [[ -d "$HOME/.homesick/repos/homeshick" ]]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    alias homesick=homeshick
fi

# hub
if type hub > /dev/null 2>&1; then
    alias git="hub"
fi

# anyenv
if [[ -d "$HOME/.anyenv/bin" ]]; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
fi

# Load local configures
[[ -f ~/.profile ]] && source ~/.profile
