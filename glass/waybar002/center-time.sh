#!/usr/bin/env bash

set -euo pipefail

state_file="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/waybar002-time-format"

if [[ -f "$state_file" && "$(<"$state_file")" == "24" ]]; then
    date '+%H:%M'
else
    date '+%I:%M'
fi
