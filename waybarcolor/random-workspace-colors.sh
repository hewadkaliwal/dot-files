#!/usr/bin/env bash

set -euo pipefail

style_file="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/style.css"
palette=(
    "#88c0d0" "#81a1c1" "#5e81ac" "#8fbcbb"
    "#a3be8c" "#ebcb8b" "#d08770" "#bf616a"
    "#b48ead" "#d8dee9" "#e5e9f0" "#c0c8d8"
    "#7fbbb3" "#dbbc7f" "#e67e80" "#d699b6"
)

mapfile -t colors < <(printf '%s\n' "${palette[@]}" | shuf -n 10)

declare -A used_colors=()
for color in "${colors[@]}"; do
    if [[ -n "${used_colors[$color]+seen}" ]]; then
        exit 1
    fi
    used_colors[$color]=1
done

for workspace in {1..10}; do
    color="${colors[$((workspace - 1))]}"
    sed -i -E "s|^@define-color workspace-${workspace} .*;|@define-color workspace-${workspace} ${color};|" "$style_file"
done
