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
function() {
    __anyenv() {
        if [[ -d "$HOME/.anyenv/bin" ]]; then
            path=("$HOME/.anyenv/bin"(N-/) $path) 
            eval "$(anyenv init - zsh)"
        fi
    }
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd __anyenv
}

# node modules
function() {
    __track_path_to_node_version() {
        if type npm > /dev/null 2>&1; then
            path=( $(npm bin)(N-/) $(npm bin -g)(N-/) $path )
        fi
    }
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd __track_path_to_node_version
}

# TypeScript
if type tvm > /dev/null 2>&1; then
    export PATH=$(which tvm | sed -e "s/bin/lib\/node_modules/")/current/bin:$PATH
fi

# trash-cli
if type trash-put > /dev/null 2>&1; then
    alias rm="trash-put"
else
    echo "'trash-cli' is not found. Please install it with the following command"
    echo
    echo "  % pip install trash-cli"
    echo
fi

# homebrew - npm
if [[ -d "/usr/local/share/npm/bin" ]]; then
    export PATH="/usr/local/share/npm/bin:$PATH"
fi

# Texlive 2011
TEXLIVE="/usr/local/texlive/2011"
if [[ -d "$TEXLIVE" ]]; then
    TEXLIVE_BIN_x86="$TEXLIVE/bin/i386-linux"
    TEXLIVE_BIN_x64="$TEXLIVE/bin/x86_64-linux"
    if [[ -d "$TEXLIVE_BIN_x86" ]]; then
        export PATH="$TEXLIVE_BIN_x87:$PATH"
    elif [[ -d "$TEXLIVE_BIN_x64" ]]; then
        export PATH="$TEXLIVE_BIN_x64:$PATH"
    fi
    export MANPATH="$TEXLIVE/texmf/doc/man:$MANPATH"
    export INFOPATH="$TEXLIVE/texmf/doc/info:$INFOPATH"
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
