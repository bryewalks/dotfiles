message="hyprpicker"
timeout=4000

# Get the output from hyprpicker and save to clipboard
output=$(hyprpicker -a -f hex)

# Split out the color only
color=$(echo "$output" | grep -oE '#[0-9A-Fa-f]{6}|#[0-9A-Fa-f]{3}')

# Create a temporary image with the color
temp_image=$(mktemp --suffix=.png)

if magick -size 25x25 xc:"$color" "$temp_image"; then
    # Send the notification with the color image
    notify-send "$message" "$color" -i "$temp_image" -t "$timeout"
else
    # Send the notification without image
    notify-send "$message" "$color" -t "$timeout"
fi

# Clean up the temporary image
rm "$temp_image"
