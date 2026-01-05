!/bin/sh
sleep 1
hyprctl dispatch workspace 2
/usr/bin/kitty +kitten panel -c "/home/brye/dotfiles/kitty/.config/kitty/kittybg.conf" --edge=background cava &
sleep 0.5
hyprctl dispatch workspace 1
kitty
