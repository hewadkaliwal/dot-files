#!/usr/bin/env bash

set -euo pipefail

workspace_id="${1:?workspace id required}"
active_workspace="$(hyprctl -j activeworkspace 2>/dev/null | jq -r '.id // -1')"
window_count="$(hyprctl -j clients 2>/dev/null | jq --argjson workspace "$workspace_id" '[.[] | select(.workspace.id == $workspace)] | length')"

if [[ "$active_workspace" == "$workspace_id" && "$window_count" =~ ^[1-9][0-9]*$ ]]; then
    exec python3 "$HOME/.config/waybar/scripts/workspace-icon.py" "$workspace_id"
fi

if [[ "$active_workspace" == "$workspace_id" ]]; then
    printf '{"text":"%s","class":"active-empty","tooltip":"Workspace %s (empty)"}\n' \
        "$workspace_id" "$workspace_id"
elif [[ "$window_count" =~ ^[1-9][0-9]*$ ]]; then
    printf '{"text":"%s","class":"inactive","tooltip":"Workspace %s"}\n' \
        "$workspace_id" "$workspace_id"
elif (( workspace_id <= 4 )); then
    printf '{"text":"%s","class":"inactive","tooltip":"Workspace %s"}\n' \
        "$workspace_id" "$workspace_id"
else
    printf '{"text":"","class":"empty","tooltip":"Workspace %s (empty)"}\n' \
        "$workspace_id"
fi
