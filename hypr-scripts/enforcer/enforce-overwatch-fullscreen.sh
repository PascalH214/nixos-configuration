#!/usr/bin/env bash

mapfile -t addresses < <(
  "$HOME/.config/hypr/scripts/enforcer/list-clients.sh" |
    while IFS=$'\t' read -r addr cls _ fullscreen title; do
      if [[ "$cls" == "gamescope" && "$title" == *overwatch* && "$fullscreen" != "2" ]]; then
        printf '%s\n' "$addr"
      fi
    done
)

for address in "${addresses[@]}"; do
  hyprctl dispatch fullscreenstate "2 2,address:0x$address" >/dev/null 2>&1
done