#!/usr/bin/env bash

set -euo pipefail

state_file="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/waybar002-time-format"

if [[ -f "$state_file" && "$(<"$state_file")" == "24" ]]; then
    rm -f "$state_file"
else
    printf '24\n' > "$state_file"
fi

pkill -RTMIN+9 -f "waybar -c /home/hewad/.config/waybar/themes/waybar002/config" 2>/dev/null || true
