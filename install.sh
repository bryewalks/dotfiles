#!/bin/bash

set -e

# Customize this with your GitHub dotfiles repo
GITHUB_USER="bryewalks"
DOTFILES_REPO="dotfiles"
DOTFILES_DIR="$HOME/dotfiles"

# Define official repo packages
OFFICIAL_PACKAGES=(
    hyprland
    hypridle
    hyprpaper
    hyprcursor
    hyprlock
    swaync
    tmux
    ttf-cascadia-code-nerd
    base-devel
    git
    stow
)

# Define AUR packages
AUR_PACKAGES=(
    waybar-cava
    proton-mail-bin
)

install_official_packages() {
    echo "📦 Installing official packages via pacman..."
    sudo pacman -Syu --noconfirm "${OFFICIAL_PACKAGES[@]}"
    echo "✅ Official packages installed."
}

install_yay_if_missing() {
    if ! command -v yay &> /dev/null; then
        echo "🔧 yay not found — installing from AUR..."
        TEMP_DIR=$(mktemp -d)
        cd "$TEMP_DIR"
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ~
        rm -rf "$TEMP_DIR"
        echo "✅ yay installed."
    else
        echo "✔️ yay is already installed."
    fi
}

install_aur_packages() {
    echo "📦 Installing AUR packages via yay..."
    yay -S --noconfirm "${AUR_PACKAGES[@]}"
    echo "✅ AUR packages installed."
}

clone_dotfiles_if_missing() {
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        echo "📁 Dotfiles directory not found. Cloning with submodules..."
        git clone --recurse-submodules "https://github.com/$GITHUB_USER/$DOTFILES_REPO.git" "$DOTFILES_DIR"
        echo "✅ Dotfiles cloned to $DOTFILES_DIR"
    else
        echo "✔️ Dotfiles directory already exists at $DOTFILES_DIR"
    fi

    echo "🔄 Ensuring submodules are initialized..."
    cd "$DOTFILES_DIR"
    git submodule update --init --recursive
    echo "✅ Submodules updated."
}

unstow_dotfiles() {
    if [[ -d "$DOTFILES_DIR" ]]; then
        echo "🗂️ Unstowing dotfiles from $DOTFILES_DIR..."
        cd "$DOTFILES_DIR"

        # Remove existing stows to prevent duplication
        for dir in */; do
            stow -D "${dir%/}" 2>/dev/null || true
        done

        stow *

        echo "✅ Dotfiles unstowed successfully."
    else
        echo "⚠️ Dotfiles directory not found — skipping stow step."
    fi
}

# Main logic
install_official_packages
install_yay_if_missing
install_aur_packages
clone_dotfiles_if_missing
unstow_dotfiles

echo "🎉 System and dotfiles (with submodules) setup complete!"
