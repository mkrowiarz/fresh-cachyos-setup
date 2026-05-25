#!/usr/bin/env bash
# Toggle a floating ccmonitor TUI popup on a Hyprland special workspace.
# First click spawns it (silent, on the special ws) and reveals it; later
# clicks just toggle the special workspace's visibility. When you quit the
# TUI (q), the window closes and the next click respawns it.
set -euo pipefail

# NOTE: ghostty only honors --class if it's a valid GTK app-ID (reverse-DNS
# with at least one dot); a bare name like "ccmonitor-popup" is silently
# ignored and falls back to com.mitchellh.ghostty, breaking the match below.
class=com.ccmonitor.popup
ws=ccmonitor

if hyprctl clients -j | jq -e ".[] | select(.class==\"$class\")" >/dev/null; then
    hyprctl dispatch togglespecialworkspace "$ws"
else
    hyprctl dispatch exec "[workspace special:$ws silent] ghostty --class=$class -e ccmonitor"
    hyprctl dispatch togglespecialworkspace "$ws"
fi
