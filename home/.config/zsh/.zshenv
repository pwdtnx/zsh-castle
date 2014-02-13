# ignore duplicated path
typeset -U path

# (N-/): do not register if the directory is not exists
#  N: NULL_GLOB option (ignore path if the path does not match the glob)
#  -: follow the symbol links
#  /: ignore files
path=(
    $HOME/.local/bin(N-/)
    $HOME/.gem/ruby/*/bin(N-/)
    /var/lib/gems/*/bin(N-/)
    /opt/local/bin(N-/)
    /usr/local/bin(N-/)
    /usr/bin(N-/)
    /bin(N-/)
    # Mac OS X
    /usr/X11/bin(N-/))

# -x: do export SUDO_PATH same time
# -T: connect SUDO_PATH and sudo_path
typeset -xT SUDO_PATH sudo_path
typeset -U sudo_path
sudo_path=({,/usr/pkg,/usr/local,/usr}/sbin(N-/))

# add sudo_path to path when the login user is root
if [[ $(id -u) -eq 0 ]]; then
    path=($sudo_path $path)
fi

# Add completion path
version=$(zsh --version | awk '{print $2}')
fpath=(
    $HOME/.homesick/repos/homeshick/completions(N-/)
    /usr/local/share/zsh/$version/functions(N-/)
    $fpath)

typeset -U manpath
manpath=(
    $HOME/.local/share/man(N-/)
    /opt/local/share/man(N-/)
    /usr/local/share/man(N-/)
    /usr/share/man(N-/))

# less
#   M - display percentage and filename
#   i - ignore case in search
#   R - display ANSI color escape sequence as colors
#   N - show linenumber (heavy)
#   S - do not wrap long lines
export LESS="-iMRS"

# grep
# use GNU grep if possible
if type ggrep > /dev/null 2>&1; then
    alias grep=ggrep
fi
grep_version="$(grep --version | head -n 1 | sed -e 's/^[^0-9.]*\([0-9.]*\)[^0-9.]*$/\1/')"
export GREP_OPTIONS
GREP_OPTIONS="--binary-files=without-match"
case "$grep_version" in
    1.*|2.[0-4].*|2.5.[0-3])
        ;;
    *)
        # grep 2.5.4 and later
        # recursively grep if the target was a directory
        GREP_OPTIONS="--directories=recurse $GREP_OPTIONS"
        ;;
esac
# ignore *.tmp, *.pyc, and version control directories or etc.
GREP_OPTIONS="--exclude=\*.tmp $GREP_OPTIONS"
GREP_OPTIONS="--exclude=\*.pyc $GREP_OPTIONS"
if grep --help 2>&1 | grep -q -- --exclude-dir; then
    GREP_OPTIONS="--exclude-dir=.svn $GREP_OPTIONS"
    GREP_OPTIONS="--exclude-dir=.git $GREP_OPTIONS"
    GREP_OPTIONS="--exclude-dir=.deps $GREP_OPTIONS"
    GREP_OPTIONS="--exclude-dir=.libs $GREP_OPTIONS"
fi
# use colorful grep if possible
if grep --help 2>&1 | grep -q -- --color; then
    GREP_OPTIONS="--color=auto $GREP_OPTIONS"
fi

# sed
# use GNU sed if possible
if type gsed > /dev/null 2>&1; then
    alias sed=gsed
fi

## vim
export EDITOR=vim
if ! type vim > /dev/null 2>&1; then
    alias vim=vi
fi

# Fix current directory issue in
# gnome-terminal 2.32 and later 
[ -f /etc/profile.d/vte.sh ] && . /etc/profile.d/vte.sh
