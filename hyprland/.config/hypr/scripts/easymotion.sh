#!/bin/sh

if hyprctl plugins list | grep -q hypreasymotion; then
  hyprctl dispatch easymotion action:hyprctl dispatch focuswindow address:{}
fi

