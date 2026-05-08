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
    [[ -d "${HOME}/.oh-my-zsh" ]] &&
    [[ -d "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k" ]]
}

# =========================================================
# Instalación
# =========================================================

install() {

    echo "[INFO] Instalando zsh"

    # -----------------------------------------------------
    # Dependencias
    # -----------------------------------------------------

    install_apt_packages \
        zsh \
        git \
        curl

    # -----------------------------------------------------
    # Instalar Oh My Zsh
    # -----------------------------------------------------

    RUNZSH=no CHSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # -----------------------------------------------------
    # Instalar Powerlevel10k
    # -----------------------------------------------------

    git clone --depth=1 \
        https://github.com/romkatv/powerlevel10k.git \
        "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"

    # -----------------------------------------------------
    # Copiar dotfiles
    # -----------------------------------------------------

    cp configs/dotfiles/.zshrc "${HOME}/.zshrc"

    cp configs/dotfiles/.p10k.zsh "${HOME}/.p10k.zsh"

    # -----------------------------------------------------
    # Cambiar shell por defecto
    # -----------------------------------------------------

    chsh -s "$(which zsh)"

    echo "[INFO] zsh instalado correctamente"
}
