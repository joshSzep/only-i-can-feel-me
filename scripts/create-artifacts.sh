#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

run_step() {
  local script_name=$1
  local script_path="$script_dir/$script_name"

  if [[ ! -f "$script_path" ]]; then
    printf 'Required script not found: %s\n' "$script_path" >&2
    exit 1
  fi

  printf 'Running %s\n' "$script_name"
  bash "$script_path"
}

run_step create-manuscript.sh
run_step create-pdf.sh
run_step create-website.sh