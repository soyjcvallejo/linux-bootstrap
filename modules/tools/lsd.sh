#!/usr/bin/env bash

name="lsd"

description="Modern ls replacement written in Rust"

check() {
    command_exists lsd
}

install() {

    echo "[INFO] Instalando lsd"

    local url

    url="$(get_latest_github_deb_url \
        "lsd-rs/lsd" \
        "amd64.deb")"

    install_deb_from_url "$url"
}
