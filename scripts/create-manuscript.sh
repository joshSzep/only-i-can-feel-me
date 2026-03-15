#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd -- "$script_dir/.." && pwd)
chapters_dir="$repo_root/chapters"
output_file="$repo_root/MANUSCRIPT.md"
tmp_file=$(mktemp "${TMPDIR:-/tmp}/only-i-can-feel-me-manuscript.XXXXXX")

cleanup() {
  rm -f "$tmp_file"
}

trap cleanup EXIT

sort_key_from_name() {
  local name=$1
  local prefix=$2
  local number

  number=$(printf '%s\n' "$name" | sed -E -n "s/^${prefix} ([0-9]+).*/\\1/p")

  if [[ -z "$number" ]]; then
    number=999999
  fi

  printf '%s\n' "$number"
}

sorted_act_dirs() {
  find "$chapters_dir" -mindepth 1 -maxdepth 1 -type d | while IFS= read -r act_dir; do
    local act_name act_number

    act_name=$(basename "$act_dir")
    act_number=$(sort_key_from_name "$act_name" "Act")
    printf '%s\t%s\n' "$act_number" "$act_dir"
  done | sort -t $'\t' -k1,1n -k2,2 | cut -f2-
}

sorted_chapter_files() {
  local act_dir=$1

  find "$act_dir" -mindepth 1 -maxdepth 1 -type f -name '*.md' | while IFS= read -r chapter_file; do
    local chapter_name chapter_number

    chapter_name=$(basename "$chapter_file")
    chapter_number=$(sort_key_from_name "$chapter_name" "Chapter")
    printf '%s\t%s\n' "$chapter_number" "$chapter_file"
  done | sort -t $'\t' -k1,1n -k2,2 | cut -f2-
}

render_chapter_body() {
  local chapter_file=$1
  local chapter_title=$2

  awk -v title="$chapter_title" '
    NR == 1 && $0 == "# " title {
      skipping = 1
      next
    }
    skipping && $0 == "" {
      next
    }
    {
      skipping = 0
      print
    }
  ' "$chapter_file"
}

if [[ ! -d "$chapters_dir" ]]; then
  printf 'Chapters directory not found: %s\n' "$chapters_dir" >&2
  exit 1
fi

printf '# Only I Can Feel Me\n\nA Novel - Joshua Szepietowski\n' > "$tmp_file"

while IFS= read -r act_dir; do
  [[ -n "$act_dir" ]] || continue

  act_name=$(basename "$act_dir")
  printf '\n## %s\n' "$act_name" >> "$tmp_file"

  while IFS= read -r chapter_file; do
    [[ -n "$chapter_file" ]] || continue

    chapter_name=$(basename "$chapter_file" .md)
    printf '\n### %s\n\n' "$chapter_name" >> "$tmp_file"
    render_chapter_body "$chapter_file" "$chapter_name" >> "$tmp_file"
  done < <(sorted_chapter_files "$act_dir")
done < <(sorted_act_dirs)

printf '\n' >> "$tmp_file"
mv "$tmp_file" "$output_file"

printf 'Wrote %s\n' "$output_file"