Bundle seebi/dircolors-solarized
export LS_COLORS
DIRCOLORS="${ZDOTDIR}/bundle/dircolors-solarized/dircolors.ansi-dark"
if type dircolors > /dev/null 2>&1; then
    eval $(dircolors ${DIRCOLORS})
elif type gdircolors > /dev/null 2>&1; then
    eval $(gdircolors ${DIRCOLORS})
fi
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
