#!/usr/bin/env bash

while true; do
  "$HOME/.config/hypr/scripts/enforcer/enforce-special.sh"
  "$HOME/.config/hypr/scripts/enforcer/enforce-workspace9.sh"
  "$HOME/.config/hypr/scripts/enforcer/enforce-overwatch-fullscreen.sh"

  sleep 0.5
done