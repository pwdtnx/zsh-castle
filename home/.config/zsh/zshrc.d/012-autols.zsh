#
# Automatically call ls when the current directory has changed
#
function() {
    __autols() {
        if type abbrls >/dev/null 2>&1; then
            # use abbrls if exists
            abbrls
        else
            ls
        fi
    }
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd __autols
}
