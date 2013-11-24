# homeshick
if [[ -d "$HOME/.homesick/repos/homeshick" ]]; then
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    alias homesick=homeshick
fi

# phantomjs
if [[ -d "$HOME/.phantomjs" ]]; then
    export PATH="$PATH:$HOME/.phantomjs/bin/"
fi

# hub
if type hub > /dev/null 2>&1; then
    alias git="hub"
fi

# bpython
if type bpython > /dev/null 2>&1; then
    alias python="bpython"
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

# homebrew - npm
if [[ -d "/usr/local/share/npm/bin" ]]; then
    export PATH="/usr/local/share/npm/bin:$PATH"
fi

# Texlive 2011
TEXLIVE="/usr/local/texlive/2011"
TEXLIVE_BIN_x86="$TEXLIVE/bin/i386-linux"
TEXLIVE_BIN_x64="$TEXLIVE/bin/x86_64-linux"
if [[ -d "$TEXLIVE_BIN_x86" ]]; then
    export PATH="$TEXLIVE_BIN_x87:$PATH"
elif [[ -d "$TEXLIVE_BIN_x64" ]]; then
    export PATH="$TEXLIVE_BIN_x64:$PATH"
fi
export MANPATH="$TEXLIVE/texmf/doc/man:$MANPATH"
export INFOPATH="$TEXLIVE/texmf/doc/info:$INFOPATH"

# Load local configures
[[ -f ~/.zshrc ]] && source ~/.zshrc
[[ -f ~/.profile ]] && source ~/.profile
