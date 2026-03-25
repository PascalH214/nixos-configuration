#!/bin/bash

# Notification ID for replacing notifications
NOTIF_ID=9994

# Get the PID of the focused window
FOCUSED_PID=$(hyprctl activewindow -j | jq -r '.pid')

if [ -z "$FOCUSED_PID" ] || [ "$FOCUSED_PID" = "null" ]; then
    notify-send -i dialog-warning "App Volume" "No focused window found"
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
    notify-send -i audio-volume-muted "App Volume" "No audio stream found for $PROCESS_NAME"
    exit 1
fi

# Perform the volume action
case "$1" in
    up)
        pactl set-sink-input-volume "$SINK_INPUT" +1%
        VOLUME=$(pactl list sink-inputs | grep -A 10 "Sink Input #$SINK_INPUT" | grep "Volume:" | head -n1 | grep -oP '\d+%' | head -n1 | tr -d '%')
        notify-send -r $NOTIF_ID -i audio-volume-high -t 1000 "App Volume" "$VOLUME%"
        ;;
    down)
        pactl set-sink-input-volume "$SINK_INPUT" -1%
        VOLUME=$(pactl list sink-inputs | grep -A 10 "Sink Input #$SINK_INPUT" | grep "Volume:" | head -n1 | grep -oP '\d+%' | head -n1 | tr -d '%')
        notify-send -r $NOTIF_ID -i audio-volume-low -t 1000 "App Volume" "$VOLUME%"
        ;;
    mute)
        pactl set-sink-input-mute "$SINK_INPUT" toggle
        MUTED=$(pactl list sink-inputs | grep -A 10 "Sink Input #$SINK_INPUT" | grep "Mute:" | awk '{print $2}')
        if [ "$MUTED" = "yes" ]; then
            notify-send -r $NOTIF_ID -i audio-volume-muted -t 1000 "App Volume" "Muted"
        else
            notify-send -r $NOTIF_ID -i audio-volume-medium -t 1000 "App Volume" "Unmuted"
        fi
        ;;
esac
