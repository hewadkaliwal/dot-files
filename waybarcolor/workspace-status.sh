#!/usr/bin/env bash

workspace_id="${1:-1}"
active_workspace=$(hyprctl -j activeworkspace 2>/dev/null | jq -r '.id // -1')
window_count=$(hyprctl -j clients 2>/dev/null | jq --argjson workspace "$workspace_id" '[.[] | select(.workspace.id == $workspace)] | length' 2>/dev/null)

if [[ "$active_workspace" == "$workspace_id" && "$window_count" =~ ^[1-9][0-9]*$ ]]; then
  exec python3 "$HOME/.config/waybar/scripts/workspace-icon.py" "$workspace_id"
fi

if [[ "$active_workspace" == "$workspace_id" ]]; then
  workspace_class="active-empty"
elif [[ "$window_count" =~ ^[1-9][0-9]*$ ]]; then
  workspace_class="inactive"
else
  printf '{"text":"","class":"empty","tooltip":"Workspace %s"}\n' "$workspace_id"
  exit 0
fi

printf '{"text":"●","class":"%s","tooltip":"Workspace %s"}\n' \
  "$workspace_class" "$workspace_id"
