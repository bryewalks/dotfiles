#!/bin/bash

set -e

# Customize this with your GitHub dotfiles repo
GITHUB_USER="bryewalks"
DOTFILES_REPO="dotfiles"
DOTFILES_DIR="$HOME/dotfiles"

# Define official repo packages
OFFICIAL_PACKAGES=(
    base-devel
    bitwarden
    discord
    fastfetch
    git
    helvum
    hyprcursor
    hypridle
    hyprland
    hyprlock
    hyprpaper
    hyprshot
    kitty
    lsd
    neovim
    rofi
    steam
    stow
    swaync
    tmux
    ttf-cascadia-code-nerd
    ttf-cascadia-mono-nerd
    zsh
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
        echo "✅ yay is already installed."
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
        echo "✅ Dotfiles directory already exists at $DOTFILES_DIR"
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

        stow */

        echo "✅ Dotfiles unstowed successfully."
    else
        echo "⚠️ Dotfiles directory not found — skipping stow step."
    fi
}

set_zsh_as_default() {
    echo "🔄 Setting Zsh as the default shell..."
    chsh -s "$(which zsh)"
    echo "✅ Zsh set as the default shell. Please log out and log back in for changes to take effect."
}

start_tmux_and_install_plugins() {
    echo "🔄 Starting tmux..."
    tmux new-session -d -s mysession  # Start a new tmux session in detached mode

    # Install tmux plugins
    echo "🔄 Installing tmux plugins..."
    tmux source-file ~/.tmux.conf  # Reload tmux configuration to load plugins
    tmux run-shell '~/.tmux/plugins/tpm/bin/install_plugins'  # Install plugins
    echo "✅ tmux plugins installed."

    # Stop the tmux session
    echo "🔄 Stopping tmux session..."
    tmux kill-session -t mysession  # Kill the tmux session
    echo "✅ tmux session stopped."
}

install_node() {
    # Check if nvm is installed
    if [ -d "$HOME/.nvm" ]; then
        echo "🔄 Installing Node.js..."
        
        # Load nvm
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

        # Install the latest version of Node.js
        nvm install node
        echo "✅ Node.js installed."
    else
        echo "⚠️ nvm is not installed. Skipping Node.js installation."
    fi
}

reload_hyprland_if_running() {
    if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
        echo "🔄 Reloading Hyprland..."
        hyprctl reload
        echo "✅ Hyprland reloaded."
    else
        echo "⚠️ Hyprland is not running — skipping reload."
    fi
}


# Main logic
install_official_packages
install_yay_if_missing
install_aur_packages
clone_dotfiles_if_missing
unstow_dotfiles
start_tmux_and_install_plugins
install_node
reload_hyprland_if_running
set_zsh_as_default

echo "🎉 System and dotfiles setup complete!"
