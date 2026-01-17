#!/bin/bash
set -e

############################
# Configuration
############################

DOTFILES_DIR="$HOME/dotfiles"

OFFICIAL_PACKAGES=(
    archlinux-xdg-menu
    base-devel
    bitwarden
    btop
    cava
    chromium
    cmus
    discord
    docker
    docker-compose
    dolphin
    fastfetch
    firefox
    flatpak
    git
    helvum
    hyprcursor
    hypridle
    hyprland
    hyprlock
    hyprpaper
    hyprpicker
    hyprpolkitagent
    hyprshot
    kitty
    kvantum
    lazydocker
    loupe
    lsd
    neovim
    network-manager-applet
    openai-codex
    qt5-declarative
    qt5-quickcontrols2
    qt6-svg
    qt6-declarative
    ripgrep
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

AUR_PACKAGES=(
    icu76
    proton-mail
    waybar-cava
    waypaper
    wlogout-git
)

FLATPAKS=(
    com.stremio.Stremio
)

############################
# Styling / Logging
############################

RESET="\e[0m"
BOLD="\e[1m"
BLUE="\e[34m"
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"

log_step() { echo -e "${BLUE}${BOLD}▶ $1${RESET}"; }
log_ok()   { echo -e "${GREEN}✔ $1${RESET}"; }
log_warn() { echo -e "${YELLOW}⚠ $1${RESET}"; }
log_err()  { echo -e "${RED}✖ $1${RESET}"; }

section() {
    echo -e "\n${BOLD}=== $1 ===${RESET}"
}

############################
# Progress Bar
############################

TOTAL_STEPS=14
CURRENT_STEP=0
BAR_WIDTH=20

progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    local filled=$((CURRENT_STEP * BAR_WIDTH / TOTAL_STEPS))
    local empty=$((BAR_WIDTH - filled))

    printf "\n["
    printf "■%.0s" $(seq 1 "$filled")
    printf "□%.0s" $(seq 1 "$empty")
    printf "] %d/%d %s\n\n" "$CURRENT_STEP" "$TOTAL_STEPS" "$1"
}

############################
# Helpers
############################

require_sudo() {
    sudo -v
}

############################
# Steps
############################

install_official_packages() {
    log_step "Installing official packages"
    sudo pacman -Syu --noconfirm --needed "${OFFICIAL_PACKAGES[@]}"
    log_ok "Official packages installed"
}

install_yay_if_missing() {
    if ! command -v yay &> /dev/null; then
        log_step "Installing yay (AUR helper)"
        tmp=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$tmp" > /dev/null
        (cd "$tmp" && makepkg -si --noconfirm)
        rm -rf "$tmp"
        log_ok "yay installed"
    else
        log_ok "yay already installed"
    fi
}

install_aur_packages() {
    log_step "Installing AUR packages"
    yay -S --noconfirm --needed --quiet "${AUR_PACKAGES[@]}"
    log_ok "AUR packages installed"
}

setup_flatpak() {
    # Install flatpak if not installed
    if ! command -v flatpak &>/dev/null; then
        log_step "Installing flatpak"
        sudo pacman -S --noconfirm flatpak
    fi

    log_ok "Flatpak installed"

    # Add Flathub if not already added
    if ! flatpak remote-list | grep -q flathub; then
        log_step "Setting up flathub"
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    log_ok "Flathub configured"
}

install_flatpaks() {
    log_step "Installing flatpaks"
    sudo flatpak install -y flathub "${FLATPAKS[@]}"
    log_ok "Flatpaks installed"
}

unstow_package() {
    local pkg="$1"

    if stow "$pkg"; then
        log_ok "$pkg Configured"
    else
        log_warn "Conflicts while configuring $pkg — skipping"
    fi
}

unstow_dotfiles() {
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        log_warn "Dotfiles directory not found, skipping"
        return 0
    fi

    log_step "Configuring dotfiles"
    cd "$DOTFILES_DIR"

    for dir in */; do
        stow -D "${dir%/}" 2>/dev/null || true
    done

    for dir in */; do
        unstow_package "${dir%/}"
    done
}

tmux_plugins() {
    log_step "Installing tmux plugins"

    # 1. Check tmux is installed
    if ! command -v tmux &>/dev/null; then
        log_warn "tmux not installed, skipping tmux plugin setup"
        return 0
    fi

    # 2. Check TPM exists
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ ! -x "$tpm_dir/bin/install_plugins" ]]; then
        log_warn "TPM not found at $tpm_dir"
        log_warn "Did you forget to pull git submodules?"
        log_warn "Skipping tmux plugin installation"
        return 0
    fi

    # 3. Clean up old session if it exists
    if tmux has-session -t setup 2>/dev/null; then
        log_warn "Old tmux session 'setup' exists, killing it"
        tmux kill-session -t setup || {
            log_warn "Failed to kill existing tmux session"
            return 0
        }
    fi

    # 4. Create temporary session
    tmux new-session -d -s setup || {
        log_warn "Failed to create tmux session"
        return 0
    }

    # 5. Load config (non-fatal)
    tmux source-file ~/.tmux.conf 2>/dev/null || \
        log_warn "Failed to source ~/.tmux.conf"

    # 6. Install plugins
    if ! tmux run-shell "$tpm_dir/bin/install_plugins"; then
        log_warn "TPM plugin installation failed"
    else
        log_ok "tmux plugins installed"
    fi

    # 7. Cleanup
    tmux kill-session -t setup 2>/dev/null || true
}

install_node() {
    if [[ -d "$HOME/.nvm" ]]; then
        log_step "Installing Node.js"
        export NVM_DIR="$HOME/.nvm"
        source "$NVM_DIR/nvm.sh"
        nvm install node > /dev/null
        log_ok "Node.js installed"
    else
        log_warn "nvm not found, skipping Node.js"
    fi
}

run_hyprland_init() {
    local script="$DOTFILES_DIR/hyprland/.config/hypr/scripts/init.sh"
    if [[ -x "$script" ]]; then
        log_step "Running Hyprland init script"
        "$script"
        log_ok "Hyprland init complete"
    else
        log_warn "Hyprland init script not found"
    fi
}

install_hyprland_plugins() {
    log_step "Installing Hyprland plugins"
    HYPRLAND_REPOS=(
        https://github.com/hyprwm/hyprland-plugins
        https://github.com/bryewalks/hyprfocus
        https://github.com/bryewalks/hyprland-easymotion
        https://github.com/virtcode/hypr-dynamic-cursors
    )
    HYPRLAND_PLUGINS=(
        hyprfocus
        hyprEasymotion
        dynamic-cursors
    )

    for repo in "${HYPRLAND_REPOS[@]}"; do
        hyprpm add "$repo" || true
    done

    if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
        log_step "Enabling Hyprland plugins"
        hyprpm enable "$HYPRLAND_PLUGINS"

        log_ok "Hyprland plugins enabled"
    else
        log_warn "Hyprland plugins cannot be enabled (Hyprland not running)"
    fi
}

reload_hyprland() {
    if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
        log_step "Reloading Hyprland"
        hyprctl reload
        log_ok "Hyprland reloaded"
    fi
}

set_zsh() {
    log_step "Setting Zsh as default shell"
    chsh -s "$(which zsh)"
    log_ok "Zsh set as default shell"
}

setup_sddm() {
    log_step "Setting up SDDM"
    sddm/install.sh
    sudo systemctl enable sddm.service --now
    log_ok "SDDM enabled"
}

additional_setup() {
    log_step "Final system tweaks"
    kbuildsycoca6
    log_ok "Additional setup complete"
}

############################
# Execution
############################

require_sudo

section "Package Installation"
install_official_packages; progress "Official packages"
install_yay_if_missing;     progress "yay setup"
install_aur_packages;       progress "AUR packages"
setup_flatpak;              progress "Flatpak setup"
install_flatpaks;           progress "Flatpaks"

section "Dotfiles & Shell"
unstow_dotfiles;            progress "Dotfiles"
tmux_plugins;               progress "tmux plugins"
install_node;               progress "Node.js"
set_zsh;                    progress "Zsh default"

section "Hyprland"
run_hyprland_init;          progress "Hyprland init"
install_hyprland_plugins;   progress "Hyprland plugins"
reload_hyprland;            progress "Hyprland reload"

section "System"
setup_sddm;                 progress "SDDM"
additional_setup;           progress "Additional tweaks"

echo -e "\n${GREEN}${BOLD}🎉 System setup complete!${RESET}"
