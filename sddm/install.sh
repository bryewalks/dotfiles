#!/bin/bash

# Copy the Catppuccin Frappé theme to SDDM themes directory
sudo mkdir -p /usr/share/sddm/themes/catppuccin-frappe
sudo cp -r ~/dotfiles/sddm/catppuccin-frappe/* /usr/share/sddm/themes/catppuccin-frappe/

# Copy the SDDM config file
sudo cp ~/dotfiles/sddm/sddm.conf /etc/sddm.conf

echo "SDDM config installed."
