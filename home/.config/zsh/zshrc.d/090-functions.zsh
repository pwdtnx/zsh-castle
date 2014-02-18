# remove all pyc files in current directory and the sub directories
function remove_pyc() {
    find . -name "*.pyc" -exec rm -vf {} \;
}
