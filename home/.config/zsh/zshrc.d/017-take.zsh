#
# mkdir + cd
#
take() {
    mkdir -p $1
    cd $1
    zsh reset-prompt
}
