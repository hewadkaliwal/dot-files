#!/usr/bin/env bash

set -euo pipefail

instance="${HYPRLAND_INSTANCE_SIGNATURE:-$(hyprctl instances -j 2>/dev/null | jq -r '.[0].instance')}"
socket="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr/$instance/.socket2.sock"
lock_file="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/waybar002-workspace-events.lock"

exec 9>"$lock_file"
flock -n 9 || exit 0

if [[ ! -S "$socket" ]]; then
    exit 0
fi

while IFS= read -r event; do
    case "$event" in
        workspace\>*|activewindow\>*|openwindow\>*|closewindow\>*|movewindow\>*)
            pkill -RTMIN+8 -f "waybar -c /home/hewad/.config/waybar/themes/waybar002/config" 2>/dev/null || true
            ;;
    esac
done < <(socat -u "UNIX-CONNECT:$socket" -)
