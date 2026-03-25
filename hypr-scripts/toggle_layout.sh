#!/bin/bash

# Toggle Hyprland master layout orientation between left and center

LAYOUT_FILE="$HOME/.config/hypr/layout.conf"

if [ ! -f "$LAYOUT_FILE" ]; then
    echo "Error: Layout file not found at $LAYOUT_FILE"
    exit 1
fi

# Get current orientation
CURRENT_ORIENTATION=$(grep -oP 'orientation\s*=\s*\K\w+' "$LAYOUT_FILE")

# Toggle orientation
if [ "$CURRENT_ORIENTATION" = "left" ]; then
    NEW_ORIENTATION="center"
    hyprctl dispatch layoutmsg orientationcenter
else
    NEW_ORIENTATION="left"
    hyprctl dispatch layoutmsg orientationleft
fi

# Update the layout file for persistence
sed -i "s/orientation[[:space:]]*=[[:space:]]*[a-z]*/orientation = $NEW_ORIENTATION/" "$LAYOUT_FILE"

echo "Layout orientation toggled: $CURRENT_ORIENTATION → $NEW_ORIENTATION"
