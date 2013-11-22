# enable 256 colors when GUI is running
if [ -n "$DISPLAY" -a "$TERM" = "xterm" ]; then
    export TERM="xterm-256color"
elif [ -n "$DISPLAY" -a "$TERM" = "rxvt" ]; then
    export TERM="rxvt-256color"
elif [ -n "$DISPLAY" -a "$TERM" = "rxvt-unicode" ]; then
    export TERM="rxvt-unicode-256color"
elif [ -n "$DISPLAY" -a "$TERM" = "screen" ]; then
    export TERM="screen-256color"
fi
