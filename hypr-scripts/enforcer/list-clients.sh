#!/usr/bin/env bash

hyprctl clients 2>/dev/null | awk '
  function flush_window() {
    if (addr != "") {
      printf "%s\t%s\t%s\t%s\t%s\n", addr, cls, ws, fullscreen, title
    }
  }

  /^Window / {
    flush_window()
    addr = $2
    gsub(/->/, "", addr)
    cls = ""
    ws = ""
    fullscreen = ""
    title = ""
  }
  /^[[:space:]]*class:/ {
    cls = tolower($2)
  }
  /^[[:space:]]*workspace:/ {
    ws = $2
  }
  /^[[:space:]]*fullscreen:/ {
    fullscreen = $2
  }
  /^[[:space:]]*title:/ {
    title = tolower(substr($0, index($0, ":") + 2))
  }
  END {
    flush_window()
  }
'
