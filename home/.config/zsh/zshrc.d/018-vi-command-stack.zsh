function display_command_stack_buffer() {
    autoload -U colors && colors
    local newline=$'\n'
    # '%{%F{XXX}%}' does not work on POSTDISPLAY
    POSTDISPLAY="${newline} « '$LBUFFER'"
    zle push-line
}
zle -N display_command_stack_buffer
bindkey -a "q" display_command_stack_buffer
