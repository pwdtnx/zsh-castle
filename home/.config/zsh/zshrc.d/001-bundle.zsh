#!/usr/bin/env zsh
#
# zsh-bundle
#
#
#
bundle_root="${ZDOTDIR}/bundle"
bundle_conf="${ZDOTDIR}/config"

bundle-run-command() {
    "$@"
    if [[ $? -ne 0 ]]; then
        echo "Failed: $@"
        return 1
    else
        return 0
    fi
}

bundle-install-package-git() {
    local url=$1
    local name=$2
    bundle-run-command git clone ${url} "${bundle_root}/${name}"
}

Bundle() {
    local url=$1
    local method=$2
    local name=$3
    # complement github url
    if [[ "$url" =~ "^[^\/]*\/[^\/]*$" ]]; then
        url="git://github.com/$1"
        method="git"
    fi
    # complement name from url
    if [[ "$name" == "" ]]; then
        name=${$(basename ${url})%.*}
    fi
    # confirm presence and download
    if [[ ! -d "${bundle_root}/${name}" ]]; then
        case ${method} in
            git)
                bundle-install-package-git ${url} ${name};;
        esac
    fi
    # load bundle
    BundleLocal ${name}
}

BundleLocal() {
    local name=$1
    # load bundle
    if [[ -f "${bundle_root}/${name}/${name}.zsh" ]]; then
        source ${bundle_root}/${name}/${name}.zsh
    elif [[ -f "${bundle_root}/${name}/${name}.sh" ]]; then
        source ${bundle_root}/${name}/${name}.sh
    elif [[ -f "${bundle_root}/${name}/${name}" ]]; then
        source ${bundle_root}/${name}/${name}
    else
        fpath+=( ${bundle_root}/${name} )
    fi
    # load config
    if [[ -f "${bundle_conf}/${name}.zsh" ]]; then
        source ${bundle_conf}/${name}.zsh
    fi
}
