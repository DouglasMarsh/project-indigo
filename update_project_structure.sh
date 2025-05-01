#!/bin/bash

# --- INPUT VALIDATION ---
if [ -z "$1" ]; then
  echo "❌ Usage: $0 <project_root_dir>"
  exit 1
fi

PROJECT_ROOT="${1%/}"
YAML_FILE="$PROJECT_ROOT/project_structure.yaml"

if [ ! -f "$YAML_FILE" ]; then
  echo "❌ Error: project_structure.yaml not found in $PROJECT_ROOT"
  exit 1
fi

TEMP_STRUCTURE=$(mktemp)

echo "structure:" > "$TEMP_STRUCTURE"

# --- ROOT FILES FIRST ---
find "$PROJECT_ROOT" -maxdepth 1 -type f | sort | while read -r file; do
  echo "  - $(basename "$file")" >> "$TEMP_STRUCTURE"
done

# --- RECURSIVE FUNCTION WITH FOLDER AS MAPPED LIST ITEM ---
generate_yaml() {
  local dir="$1"
  local indent="$2"

  local entries=()
  while IFS= read -r entry; do
    entries+=("$entry")
  done < <(find "$dir" -mindepth 1 -maxdepth 1 | sort)

  for entry in "${entries[@]}"; do
    local name="$(basename "$entry")"
    if [ -d "$entry" ]; then
      echo "${indent}- $name:" >> "$TEMP_STRUCTURE"
      generate_yaml "$entry" "  ${indent}"
    elif [ -f "$entry" ]; then
      echo "${indent}- $name" >> "$TEMP_STRUCTURE"
    fi
  done
}

# --- HANDLE ROOT-LEVEL DIRECTORIES ---
for top in "$PROJECT_ROOT"/*; do
  [ -d "$top" ] || continue
  echo "  - $(basename "$top"):" >> "$TEMP_STRUCTURE"
  generate_yaml "$top" "    "
done

# --- BACKUP & INJECT STRUCTURE ---
cp "$YAML_FILE" "${YAML_FILE}.bak"

awk -v newblock="$(cat "$TEMP_STRUCTURE")" '
  BEGIN { in_struct=0 }
  /^structure:/ { print newblock; in_struct=1; next }
  in_struct && /^[^ ]/ { in_struct=0 }
  !in_struct { print }
' "$YAML_FILE" > "${YAML_FILE}.new"

mv "${YAML_FILE}.new" "$YAML_FILE"
rm "$TEMP_STRUCTURE"

echo "✅ project_structure.yaml updated (valid YAML list with recursive folders)"
echo "🛑 Backup saved as ${YAML_FILE}.bak"
