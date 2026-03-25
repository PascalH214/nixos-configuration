#!/bin/bash

# Script to cycle through audio output devices for the focused application
# Usage: output-device.sh [next|prev]

ACTION="${1:-next}"
NOTIF_ID=9995

# Get the PID of the focused window
FOCUSED_PID=$(hyprctl activewindow -j | jq -r '.pid')

if [ -z "$FOCUSED_PID" ] || [ "$FOCUSED_PID" = "null" ]; then
    notify-send -i dialog-warning "Audio Output" "No focused window found" -r $NOTIF_ID
    exit 1
fi

# Get process name and all child PIDs
PROCESS_NAME=$(ps -p "$FOCUSED_PID" -o comm= 2>/dev/null)
ALL_PIDS=$(pgrep -P "$FOCUSED_PID" | tr '\n' ' ')
ALL_PIDS="$FOCUSED_PID $ALL_PIDS"

# Find sink input by PID using pactl
SINK_INPUT=""
for pid in $ALL_PIDS; do
    SINK_INPUT=$(pactl list sink-inputs | grep -B 20 "application.process.id = \"$pid\"" | grep "Sink Input" | head -n1 | grep -oP '#\K\d+')
    if [ -n "$SINK_INPUT" ]; then
        break
    fi
done

# If not found by PID, try by process name
if [ -z "$SINK_INPUT" ] && [ -n "$PROCESS_NAME" ]; then
    SINK_INPUT=$(pactl list sink-inputs | grep -B 20 "application.name = \"$PROCESS_NAME\"" | grep "Sink Input" | head -n1 | grep -oP '#\K\d+')
fi

# Try alternative matching for Chrome/Chromium
if [ -z "$SINK_INPUT" ]; then
    case "$PROCESS_NAME" in
        chrome|chromium|google-chrome)
            SINK_INPUT=$(pactl list sink-inputs | grep -B 20 "Chrom" | grep "Sink Input" | head -n1 | grep -oP '#\K\d+')
            ;;
        firefox)
            SINK_INPUT=$(pactl list sink-inputs | grep -B 20 "Firefox" | grep "Sink Input" | head -n1 | grep -oP '#\K\d+')
            ;;
    esac
fi

if [ -z "$SINK_INPUT" ]; then
    notify-send -i audio-volume-muted "Audio Output" "No audio stream found for $PROCESS_NAME" -r $NOTIF_ID
    exit 1
fi

# Get list of all sinks (excluding null sink)
ALL_SINKS=$(pactl list short sinks | grep -v "null" | awk '{print $1}')
SINK_ARRAY=($ALL_SINKS)

if [ ${#SINK_ARRAY[@]} -lt 2 ]; then
    notify-send -i audio-card "Audio Output" "Only one sink available" -r $NOTIF_ID
    exit 1
fi

# Get current sink for this sink input
CURRENT_SINK=$(pactl list sink-inputs | grep -A 20 "Sink Input #$SINK_INPUT" | grep "Sink:" | head -1 | awk '{print $2}')
CURRENT_INDEX=-1

# Find current sink index
for i in "${!SINK_ARRAY[@]}"; do
    if [ "${SINK_ARRAY[$i]}" = "$CURRENT_SINK" ]; then
        CURRENT_INDEX=$i
        break
    fi
done

# If not found, default to 0
if [ $CURRENT_INDEX -eq -1 ]; then
    CURRENT_INDEX=0
fi

# Calculate next index
if [ "$ACTION" = "next" ]; then
    NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#SINK_ARRAY[@]} ))
else
    NEXT_INDEX=$(( (CURRENT_INDEX - 1 + ${#SINK_ARRAY[@]}) % ${#SINK_ARRAY[@]} ))
fi

NEXT_SINK="${SINK_ARRAY[$NEXT_INDEX]}"

# Get sink name first, then get its description
SINK_NAME_FULL=$(pactl get-sink-by-number "$NEXT_SINK" 2>/dev/null)

if [ -z "$SINK_NAME_FULL" ]; then
    # Fallback: extract from pactl list output
    SINK_NAME=$(pactl list sinks | grep -A 50 "^Sink #$NEXT_SINK$" | grep "Description:" | head -1 | sed 's/.*Description:[[:space:]]*//')
else
    SINK_NAME=$SINK_NAME_FULL
fi

if [ -z "$SINK_NAME" ]; then
    SINK_NAME=$NEXT_SINK
fi

# Move sink input to the new sink
pactl move-sink-input "$SINK_INPUT" "$NEXT_SINK"

# Notify user
notify-send -i audio-card "Audio Output" "$PROCESS_NAME → $SINK_NAME" -r $NOTIF_ID
