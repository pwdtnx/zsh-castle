# homeshick
if [[ -d "$HOME/.homesick/repos/homeshick" ]]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
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

# Texlive 2013
TEXLIVE="/usr/local/texlive/2013"
if [[ -d "$TEXLIVE" ]]; then
    TEXLIVE_BIN_x86="$TEXLIVE/bin/i386-linux"
    TEXLIVE_BIN_x64="$TEXLIVE/bin/x86_64-linux"
    if [[ -d "$TEXLIVE_BIN_x86" ]]; then
        export PATH="$TEXLIVE_BIN_x87:$PATH"
    elif [[ -d "$TEXLIVE_BIN_x64" ]]; then
        export PATH="$TEXLIVE_BIN_x64:$PATH"
    fi
    export MANPATH="$TEXLIVE/texmf-dist/doc/man:$MANPATH"
    export INFOPATH="$TEXLIVE/texmf-dist/doc/info:$INFOPATH"
fi

# Load local configures
[[ -f ~/.profile ]] && source ~/.profile
