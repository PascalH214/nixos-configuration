#!/bin/bash

# Toggle monitor resolution between 2560x1440 and 5120x1440

# Get the primary monitor name
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')

if [ -z "$MONITOR" ]; then
    echo "Error: Could not detect monitor"
    exit 1
fi

# Get current resolution
CURRENT_RES=$(hyprctl monitors -j | jq -r ".[0].width | tostring")

# Toggle resolution
if [ "$CURRENT_RES" = "2560" ]; then
    NEW_RES="5120x1440"
    echo "Switching to 5120x1440"
else
    NEW_RES="2560x1440"
    echo "Switching to 2560x1440"
fi

# Apply resolution change
hyprctl keyword monitor "$MONITOR,${NEW_RES}@60,0x0,1"

echo "Resolution changed to $NEW_RES"
