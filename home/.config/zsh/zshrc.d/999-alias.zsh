# homeshick
if [[ -d "$HOME/.homesick/repos/homeshick" ]]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    # if homesick is not installed, add alias
    if ! type homesick > /dev/null 2>&1; then
        alias homesick="homeshick"
    fi
fi

# phantomjs
if [[ -d "$HOME/.phantomjs" ]]; then
    export PATH="$PATH:$HOME/.phantomjs/bin/"
fi

# hub
if type hub > /dev/null 2>&1; then
    alias git="hub"
fi

# xdg-open
if type xdg-open > /dev/null 2>&1; then
    alias open="xdg-open"
fi

# cabal
if [[ -d "$HOME/.cabal/bin" ]]; then
    export PATH="$HOME/.cabal/bin:$PATH"
fi

# nodebrew
if [[ -d "$HOME/.nodebrew" ]]; then
    export PATH="$HOME/.nodebrew/current/bin:$PATH"
fi

# pythonbrew
if [[ -d "$HOME/.pythonbrew" ]]; then
    source "$HOME/.pythonbrew/etc/bashrc"
    alias mkvirtualenv="pythonbrew venv create"
    alias workon="pythonbrew venv use"
fi

# pyenv
if [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    # enable completion
    eval "$($PYENV_ROOT/bin/pyenv init -)"

    # Add MANPATH
    # It is not automatically configured so just add man path of 2.7.6
    export MANPATH="$PYENV_ROOT/versions/2.7.6/share/man:$MANPATH"

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
