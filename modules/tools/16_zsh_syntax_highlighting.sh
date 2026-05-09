#!/usr/bin/env bash

# =========================================================
# Plugin Metadata
# =========================================================

name="zsh_syntax_highlighting"
description="Syntax highlighting para Zsh"

# =========================================================
# Verificar instalación
# =========================================================

check() {

    package_installed "zsh-syntax-highlighting"
}

# =========================================================
# Instalación
# =========================================================

install() {

    echo "[INFO] Instalando zsh-syntax-highlighting"

    # -----------------------------------------------------
    # Instalar paquete usando abstracción común
    # -----------------------------------------------------

    install_apt_packages zsh-syntax-highlighting

    # -----------------------------------------------------
    # Activar en .zshrc (idempotente)
    # -----------------------------------------------------

    local rc_file="${HOME}/.zshrc"

    local line="source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

    if [[ -f "$rc_file" ]] && ! grep -qF "$line" "$rc_file"; then

        echo "[INFO] Activando zsh-syntax-highlighting en .zshrc"

        cat >> "$rc_file" <<EOF

# zsh-syntax-highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
EOF

    else
        echo "[INFO] zsh-syntax-highlighting ya configurado"
    fi
}
