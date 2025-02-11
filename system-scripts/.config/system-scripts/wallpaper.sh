#!/usr/bin/env bash

#WALLPAPER_DIR="$HOME/dotfiles/backgrounds/.config/backgrounds"
#WALL_LOC="$XDG_STATE_HOME/wallpaper"

# Get a random wallpaper that is not the current one
#WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$(readlink -e $WALL_LOC)")" | shuf -n 1)

# symlink somewhere
#ln -sf $WALLPAPER $WALL_LOC

# Apply the selected wallpaper
#hyprctl hyprpaper reload ,"$WALLPAPER"


## New Script

directory="$HOME/dotfiles/backgrounds/.config/backgrounds"
monitor=`hyprctl monitors | grep Monitor | awk '{print $2}'`

if [ -d "$directory" ]; then
    random_background=$(ls $directory/* | shuf -n 1)
    hyprctl hyprpaper &
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload $random_background
    hyprctl hyprpaper wallpaper , $random_background
fi
