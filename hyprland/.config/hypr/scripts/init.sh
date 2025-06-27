#!/bin/bash

shopt -s nullglob
files=($(dirname "$0")/../hyprland.*.conf)
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
    echo "No hyprland.*.conf files found."
    exit 1
fi

echo "Available configurations:"
select file in "${files[@]}"; do
    if [ -n "$file" ]; then
        cp "$file" "$(dirname "$0")/../hyprland.conf"
        echo "Copied $file to hyprland.conf"
        break
    else
        echo "Invalid selection."
    fi
done
