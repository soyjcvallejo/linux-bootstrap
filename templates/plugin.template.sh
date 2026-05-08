#!/usr/bin/env bash

# =========================================================
# Plugin Metadata
# =========================================================

name="plugin-name"

description="Plugin description"

# =========================================================
# Verificar instalación
# =========================================================

check() {
    command_exists plugin-name
}

# =========================================================
# Instalación
# =========================================================

install() {

    echo "[INFO] Instalando plugin-name"

    # -----------------------------------------------------
    # Ejemplo instalación apt
    # -----------------------------------------------------

    # install_apt_packages git curl

    # -----------------------------------------------------
    # Ejemplo instalación .deb desde GitHub Releases
    # -----------------------------------------------------

    # local url
    #
    # url="$(get_latest_github_deb_url \
    #     "owner/repo" \
    #     "amd64.deb")"
    #
    # install_deb_from_url "$url"

}
