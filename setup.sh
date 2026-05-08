#!/usr/bin/env bash

set -euo pipefail

# =========================================================
# Variables globales
# =========================================================

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIGS_DIR="${BASE_DIR}/configs"
PLUGINS_DIR="${BASE_DIR}/modules/tools"
LIB_DIR="${BASE_DIR}/lib"

# =========================================================
# Dependencias base
# =========================================================

CORE_DEPENDENCIES=(
    curl
    wget
    jq
)

# =========================================================
# Logging
# =========================================================

log() {
    echo "[INFO] $1"
}

# =========================================================
# Instalar dependencias base
# =========================================================

install_core_dependencies() {

    local missing=()

    for package in "${CORE_DEPENDENCIES[@]}"; do

        if ! dpkg -s "$package" >/dev/null 2>&1; then
            missing+=("$package")
        fi
    done

    if [[ "${#missing[@]}" -gt 0 ]]; then

        log "Instalando dependencias base: ${missing[*]}"

        sudo apt-get update

        sudo apt-get install -y "${missing[@]}"
    fi
}

# =========================================================
# Cargar perfil
# =========================================================

load_profile() {

    local profile="${1:-vps}"

    PROFILE_FILE="${CONFIGS_DIR}/profiles/${profile}.conf"

    if [[ ! -f "$PROFILE_FILE" ]]; then

        echo "[ERROR] Perfil no encontrado: $profile"

        exit 1
    fi

    source "$PROFILE_FILE"
}

# =========================================================
# Cargar librerías
# =========================================================

load_libraries() {

    for lib in "$LIB_DIR"/*.sh; do
        source "$lib"
    done
}

# =========================================================
# Ejecutar plugins
# =========================================================

run_plugins() {

    for plugin in "$PLUGINS_DIR"/*.sh; do

        unset name
        unset description

        source "$plugin"

        if [[ -z "${name:-}" ]]; then
            echo "[ERROR] Plugin inválido: $plugin"
            continue
        fi

        local var="INSTALL_${name^^}"

        if [[ "${!var:-false}" != "true" ]]; then
            log "Plugin deshabilitado: $name"
            continue
        fi

        log "Plugin habilitado: $name"

        if check; then
            log "$name ya instalado"
            continue
        fi

        install
    done
}

# =========================================================
# Main
# =========================================================

main() {

    if [[ "${1:-}" != "--profile" ]]; then

        echo "Uso: ./setup.sh --profile vps"

        exit 1
    fi

    install_core_dependencies

    load_profile "${2:-vps}"

    load_libraries

    run_plugins

    log "Bootstrap completado"
}

main "$@"
