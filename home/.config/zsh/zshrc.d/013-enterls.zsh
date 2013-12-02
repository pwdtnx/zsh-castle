function() {
    __enterls() {
        if [[ -z "$BUFFER" ]]; then
            echo
            if type abbrls >/dev/null 2>&1; then
                # use abbrls if exists
                abbrls
            else
                ls
            fi
            zle reset-prompt
        else
            # there are some input so ignore enterls
            zle accept-line
        fi
    }
    zle -N __enterls
    bindkey '^m' __enterls
}
