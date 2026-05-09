#!/usr/bin/env bash

name="bat"

description="Cat clone with syntax highlighting"

check() {
    command_exists bat
}

install() {

    echo "[INFO] Instalando bat"

    local url

    url="$(get_latest_github_deb_url \
        "sharkdp/bat" \
        "amd64.deb")"

    install_deb_from_url "$url"
}
