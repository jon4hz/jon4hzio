#!/bin/sh

get_latest_release() {
    curl --silent "https://api.github.com/repos/gohugoio/hugo/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/' |
    cut -c2-
}

latest_hugo_version=$(get_latest_release)

wget "https://github.com/gohugoio/hugo/releases/download/v${latest_hugo_version}/hugo_${latest_hugo_version}_Linux-64bit.tar.gz"

tar xavf "hugo_${latest_hugo_version}_Linux-64bit.tar.gz"