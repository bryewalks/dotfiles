#!/bin/bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

# Define official repo packages
OFFICIAL_PACKAGES=(
    archlinux-xdg-menu
    base-devel
    bitwarden
    btop
    cava
    chromium # Used for web app view
    discord
    docker
    docker-compose
    dolphin
    fastfetch
    firefox # Preferred browser
    git
    helvum
    hyprcursor
    hypridle
    hyprland
    hyprlock
    hyprpaper
    hyprpolkitagent
    hyprshot
    kitty
    kvantum
    loupe
    lsd
    neovim
    network-manager-applet
    qt5-declarative
    qt5-quickcontrols2
    qt6-svg
    qt6-declarative
    rofi
    sddm
    spotify-launcher
    steam
    stow
    swaync
    tmux
    ttf-cascadia-code-nerd
    ttf-cascadia-mono-nerd
    vlc
    xdg-desktop-portal-hyprland
    zsh
)

# Define AUR packages
AUR_PACKAGES=(
    lazydocker
    proton-mail-bin
    spicetify-cli
    stremio
    waybar-cava
    waypaper
    wlogout-git
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
    yay -Syu --noconfirm "${AUR_PACKAGES[@]}"
    echo "✅ AUR packages installed."
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

run_hyprland_init() {
    if [[ -x "$DOTFILES_DIR/hyprland/.config/hypr/scripts/init.sh" ]]; then
        echo "🔄 Running Hyprland init script..."
        "$DOTFILES_DIR/hyprland/.config/hypr/scripts/init.sh"
        echo "✅ Hyprland init script executed."
    else
        echo "⚠️ Hyprland init script not found or not executable at $DOTFILES_DIR/hyprland/.config/hypr/scripts/init.sh"
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

setup_sddm() {
    echo "🔄 Setting up SDDM..."
    sddm/install.sh  
    sudo systemctl enable sddm.service --now
    echo "✅ SDDM setup complete. Please log out and log back in to apply changes."
}

additional_setup() {
    echo "🔄 Performing additional setup tasks..."
    # Add any additional setup tasks here
    # For example, you might want to set up a wallpaper, configure Hyprland settings, etc.
    kbuildsycoca6  # Rebuild KDE service cache needed for dolphin to recognize new applications

    # Set up Spotify theme *this needs to happen after logging in to spotify
    # spicetify config current_theme Dracula
    # spicetify backup apply
    echo "✅ Additional setup tasks completed."
}


# Main logic
install_official_packages
install_yay_if_missing
install_aur_packages
unstow_dotfiles
start_tmux_and_install_plugins
install_node
run_hyprland_init
reload_hyprland_if_running
set_zsh_as_default
setup_sddm
additional_setup

echo "🎉 System and dotfiles setup complete!"
