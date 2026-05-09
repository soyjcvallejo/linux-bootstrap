#!/usr/bin/env bash

# =========================================================
# Plugin Metadata
# =========================================================

name="zsh"
description="ZSH + Oh My Zsh + Powerlevel10k"

# =========================================================
# Verificar instalación
# =========================================================

check() {

    command_exists zsh &&
    [[ -d "${HOME}/.oh-my-zsh" ]]
}

# =========================================================
# Instalación
# =========================================================

install() {

    echo "[INFO] Instalando zsh"

    # -----------------------------------------------------
    # Dependencias base
    # -----------------------------------------------------

    install_apt_packages zsh git curl

    # -----------------------------------------------------
    # Oh My Zsh (idempotente básico)
    # -----------------------------------------------------

    if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then

        RUNZSH=no CHSH=no sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    else
        echo "[INFO] Oh My Zsh ya instalado"
    fi

    # -----------------------------------------------------
    # Powerlevel10k
    # -----------------------------------------------------

    local p10k_dir="${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"

    if [[ ! -d "$p10k_dir" ]]; then

        git clone --depth=1 \
            https://github.com/romkatv/powerlevel10k.git \
            "$p10k_dir"

    else
        echo "[INFO] Powerlevel10k ya instalado"
    fi

    # -----------------------------------------------------
    # Dotfiles (con backup)
    # -----------------------------------------------------

    if [[ -f "${HOME}/.zshrc" ]]; then
        cp "${HOME}/.zshrc" "${HOME}/.zshrc.backup.$(date +%s)"
    fi

    cp configs/dotfiles/.zshrc "${HOME}/.zshrc"
    cp configs/dotfiles/.p10k.zsh "${HOME}/.p10k.zsh"

    # -----------------------------------------------------
    # Cambiar shell (solo si existe zsh)
    # -----------------------------------------------------

    if command_exists zsh; then
        chsh -s "$(which zsh)" || true
    fi

    echo "[INFO] zsh instalado correctamente"
}
