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
    loupe
    lsd
    neovim
    network-manager-applet
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
    lazydocker
    opencode-bin
    proton-mail-bin
    spicetify-cli
    stremio
    vesktop
    waybar-cava
    waypaper
    wlogout-git
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

TOTAL_STEPS=12
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

run_quiet() {
    "$@" > /dev/null 2>&1
}

require_sudo() {
    sudo -v
}

############################
# Steps
############################

install_official_packages() {
    log_step "Installing official packages"
    run_quiet sudo pacman -Syu --noconfirm --needed "${OFFICIAL_PACKAGES[@]}"
    log_ok "Official packages installed"
}

install_yay_if_missing() {
    if ! command -v yay &> /dev/null; then
        log_step "Installing yay (AUR helper)"
        tmp=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$tmp" > /dev/null
        (cd "$tmp" && run_quiet makepkg -si --noconfirm)
        rm -rf "$tmp"
        log_ok "yay installed"
    else
        log_ok "yay already installed"
    fi
}

install_aur_packages() {
    log_step "Installing AUR packages"
    run_quiet yay -Syu --noconfirm --needed "${AUR_PACKAGES[@]}"
    log_ok "AUR packages installed"
}

unstow_dotfiles() {
    if [[ -d "$DOTFILES_DIR" ]]; then
        log_step "Stowing dotfiles"
        cd "$DOTFILES_DIR"
        for dir in */; do
            stow -D "${dir%/}" 2>/dev/null || true
        done
        stow */
        log_ok "Dotfiles stowed"
    else
        log_warn "Dotfiles directory not found, skipping"
    fi
}

tmux_plugins() {
    log_step "Installing tmux plugins"
    tmux new-session -d -s setup >/dev/null
    tmux source-file ~/.tmux.conf
    tmux run-shell '~/.tmux/plugins/tpm/bin/install_plugins'
    tmux kill-session -t setup
    log_ok "tmux plugins installed"
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
    hyprpm add https://github.com/hyprwm/hyprland-plugins || true
    hyprpm add https://github.com/bryewalks/hyprfocus || true
    hyprpm add https://github.com/bryewalks/hyprland-easymotion || true
    hyprpm add https://github.com/virtcode/hypr-dynamic-cursors || true

    hyprpm enable hyprfocus
    hyprpm enable hyprEasymotion
    hyprpm enable dynamic-cursors
    log_ok "Hyprland plugins enabled"
}

reload_hyprland() {
    if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
        log_step "Reloading Hyprland"
        hyprctl reload
        log_ok "Hyprland reloaded"
    else
        log_warn "Hyprland not running"
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
additional_setup;           progress "Final setup"

echo -e "\n${GREEN}${BOLD}🎉 System setup complete!${RESET}"
