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
# Mostrar plugins
# =========================================================

list_plugins() {

    printf "\n%-15s %-10s\n" "PLUGIN" "ENABLED"

    for plugin in "$PLUGINS_DIR"/*.sh; do

        unset name
        unset description

        source "$plugin"

	local normalized_name="${name^^}"
	normalized_name="${normalized_name//-/_}"
	local var="INSTALL_${normalized_name}"

        printf "%-15s %-10s\n" \
            "$name" \
            "${!var:-false}"
    done

    echo
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

	local normalized_name="${name^^}"
	normalized_name="${normalized_name//-/_}"
	local var="INSTALL_${normalized_name}"

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
# Mostrar ayuda
# =========================================================

usage() {

    cat <<EOF

Uso:

./setup.sh --profile vps
./setup.sh --list --profile vps

EOF
}

# =========================================================
# Main
# =========================================================

main() {

    if [[ $# -eq 0 ]]; then
        usage
        exit 1
    fi

    local profile="vps"
    local list_mode="false"

    while [[ $# -gt 0 ]]; do

        case "$1" in

            --profile)
                profile="$2"
                shift 2
                ;;

            --list)
                list_mode="true"
                shift
                ;;

            *)
                usage
                exit 1
                ;;
        esac
    done

    install_core_dependencies

    load_profile "$profile"

    load_libraries

    if [[ "$list_mode" == "true" ]]; then
        list_plugins
        exit 0
    fi

    run_plugins

    log "Bootstrap completado"
}

main "$@"
