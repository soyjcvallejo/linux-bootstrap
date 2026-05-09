#!/usr/bin/env bash

# =========================================================
# Plugin Metadata
# =========================================================

name="zsh_autosuggestions"
description="Autosuggestions para Zsh"

# =========================================================
# Verificar instalación
# =========================================================

check() {

    package_installed "zsh-autosuggestions"
}

# =========================================================
# Instalación
# =========================================================

install() {

    echo "[INFO] Instalando zsh-autosuggestions"

    # -----------------------------------------------------
    # Instalar paquete
    # -----------------------------------------------------

    install_apt_packages zsh-autosuggestions

    # -----------------------------------------------------
    # Activar en .zshrc
    # -----------------------------------------------------

    local rc_file="${HOME}/.zshrc"

    local line="source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

    if [[ -f "$rc_file" ]] && ! grep -qF "$line" "$rc_file"; then

        echo "[INFO] Activando zsh-autosuggestions en .zshrc"

        cat >> "$rc_file" <<EOF

# zsh-autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
EOF

    else
        echo "[INFO] zsh-autosuggestions ya configurado"
    fi
}
