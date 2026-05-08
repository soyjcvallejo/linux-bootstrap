#!/usr/bin/env bash

# =========================================================
# Common Library
# Funciones reutilizables
# =========================================================

# ---------------------------------------------------------
# Verificar si un comando existe
# ---------------------------------------------------------

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ---------------------------------------------------------
# Verificar si un paquete está instalado
# ---------------------------------------------------------

package_installed() {
    dpkg -s "$1" >/dev/null 2>&1
}

# ---------------------------------------------------------
# Instalar paquetes apt
# ---------------------------------------------------------

install_apt_packages() {

    local missing=()

    for package in "$@"; do

        if ! package_installed "$package"; then
            missing+=("$package")
        fi
    done

    if [[ "${#missing[@]}" -eq 0 ]]; then
        return
    fi

    echo "[INFO] Instalando paquetes: ${missing[*]}"

    sudo apt-get update

    sudo apt-get install -y "${missing[@]}"
}

# ---------------------------------------------------------
# Instalar paquete .deb desde URL
# ---------------------------------------------------------

install_deb_from_url() {

    local url="$1"

    if [[ -z "$url" ]]; then
        echo "[ERROR] URL vacía"
        return 1
    fi

    local filename
    filename="$(basename "$url")"

    local tmp_dir
    tmp_dir="$(mktemp -d)"

    wget -q --show-progress "$url" \
        -O "${tmp_dir}/${filename}"

    sudo dpkg -i "${tmp_dir}/${filename}" \
        || sudo apt-get install -f -y

    rm -rf "$tmp_dir"
}

# ---------------------------------------------------------
# Obtener URL del último release GitHub
# ---------------------------------------------------------

get_latest_github_deb_url() {

    local repo="$1"
    local pattern="$2"

    curl -s "https://api.github.com/repos/${repo}/releases/latest" \
        | jq -r --arg pattern "$pattern" '
            .assets[]
            | select(
                (.name | test($pattern))
                and
                (.name | contains("musl") | not)
            )
            | .browser_download_url
        ' \
        | head -n 1
}
