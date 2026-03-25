#!/usr/bin/env bash

target_workspace="${1:-}"
shift || true

if [[ -z "$target_workspace" || "$#" -eq 0 ]]; then
  exit 1
fi

declare -A target_classes=()
for class_name in "$@"; do
  target_classes["${class_name,,}"]=1
done

mapfile -t addresses < <(
  "$HOME/.config/hypr/scripts/enforcer/list-clients.sh" |
    while IFS=$'\t' read -r addr cls ws _ _; do
      if [[ -n "$addr" && -n "${target_classes[$cls]:-}" && "$ws" != "$target_workspace" ]]; then
        printf '%s\n' "$addr"
      fi
    done
)

for address in "${addresses[@]}"; do
  hyprctl dispatch movetoworkspacesilent "$target_workspace,address:0x$address" >/dev/null 2>&1
done
