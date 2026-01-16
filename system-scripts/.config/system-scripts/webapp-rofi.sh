#!/usr/bin/env bash
set -euo pipefail

HIST_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/webapp-rofi/history.txt"
mkdir -p "$(dirname "$HIST_FILE")"
touch "$HIST_FILE"

CLEAR_ITEM="Clear History"

# Show history in rofi (newest first), allow typing a new entry
while true; do
  sel="$(
    {
      tac "$HIST_FILE"
      printf '%s\n' "$CLEAR_ITEM"
    } | rofi -dmenu -i -p "WebApp URL" -l 12 \
      -theme-str '
        textbox-prompt-colon { 
          str: "🌐";
        }

        listview {
          fixed-height: false;
        }
        
        entry {
          placeholder: "URL...";
          padding-left: 0;
        }'
  )"
  #
  # Trim whitespace + strip CR (just in case)
  sel="$(printf '%s' "$sel" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

  # Cancel/empty -> quit
  [ -n "$sel" ] || exit 0

  # Clear history item chosen
  if [ "$sel" = "$CLEAR_ITEM" ]; then
    : > "$HIST_FILE"
    notify-send "WebApp Launcher" "History cleared"
    continue
  fi

  url="$sel"

  # If it's a bare domain, prepend https://
  if [[ "$url" != *"://"* ]] && [[ "$url" == *"."* ]]; then
    url="https://$url"
  fi

  # Final safety: never launch empty
  [ -n "$url" ] || exit 0

  # Save to history, dedupe (most recent wins)
  {
    cat "$HIST_FILE"
    printf '%s\n' "$url"
  } | tac | awk 'NF && !seen[$0]++' | tac > "${HIST_FILE}.tmp"
  mv "${HIST_FILE}.tmp" "$HIST_FILE"

  chromium --new-window --ozone-platform=wayland --app="$url"
  exit 0
done
