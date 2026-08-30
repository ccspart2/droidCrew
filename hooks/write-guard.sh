#!/usr/bin/env bash
# droidCrew write guard (PreToolUse on Write/Edit).
# Blocks edits to application source unless the active droidCrew stage is `code`.
# Only active when docs/droidcrew/.stage exists in the project and guard.enabled is not false.
# Exit 0 = allow. Exit 2 = block (stderr is shown to the model).
#
# Portability: uses python3 when available and falls back to sed, so the guard still
# works on machines without python3. It never fails silently — if the tool input cannot
# be parsed at all, it says so on stderr rather than quietly allowing the write.

set -u
input="$(cat)"
project="${CLAUDE_PROJECT_DIR:-$PWD}"
stage_file="$project/docs/droidcrew/.stage"
config="$project/docs/droidcrew/config.json"

[ -f "$stage_file" ] || exit 0

stage="$(tr -d '[:space:]' < "$stage_file")"
[ "$stage" = "code" ] && exit 0

have_python=0
if command -v python3 >/dev/null 2>&1 && python3 -c '' >/dev/null 2>&1; then
  have_python=1
fi

# guard.enabled
if [ -f "$config" ]; then
  if [ "$have_python" = 1 ]; then
    enabled="$(python3 -c 'import json,sys; print(str(json.load(open(sys.argv[1])).get("guard",{}).get("enabled",True)).lower())' "$config" 2>/dev/null || echo true)"
  else
    # crude but sufficient: look for "enabled": false inside the guard object
    if tr -d ' \n\t' < "$config" | grep -q '"guard":{[^}]*"enabled":false'; then
      enabled=false
    else
      enabled=true
    fi
  fi
  [ "$enabled" = "false" ] && exit 0
fi

# tool_input.file_path (or notebook_path)
path=""
if [ "$have_python" = 1 ]; then
  path="$(printf '%s' "$input" | python3 -c 'import json,sys
try:
    d=json.load(sys.stdin); ti=d.get("tool_input",{})
    print(ti.get("file_path") or ti.get("notebook_path") or "")
except Exception: print("")' 2>/dev/null)"
fi

if [ -z "$path" ]; then
  # sed fallback: first "file_path":"..." or "notebook_path":"..." in the payload
  # -E: BSD sed has no \| alternation in basic regex, so extended is required here.
  path="$(printf '%s' "$input" | tr -d '\n' | sed -nE 's/.*"(file_path|notebook_path)"[[:space:]]*:[[:space:]]*"([^"]*)".*/\2/p')"
fi

if [ -z "$path" ]; then
  echo "droidCrew write guard: could not read a file path from the tool input, so this write was NOT checked. The guard is not protecting your source right now — report this with the tool name." >&2
  exit 0
fi

rel="${path#"$project"/}"

# Always allowed: crew state, docs, screenshots, scratch.
case "$rel" in
  docs/*|.claude/*|*.md|/private/tmp/*|/tmp/*|/var/folders/*) exit 0 ;;
esac

# Application source and build files.
case "$rel" in
  *.kt|*.kts|*.java|*.gradle|*.pro|*.xml|*.toml|*.properties|*/src/*|src/*|gradle/*|gradlew*)
    echo "droidCrew write guard: stage is '$stage', and only the Coder (stage 'code') may edit application source ($rel). Route the change through /droidcrew:plan → /droidcrew:code, or disable the guard in docs/droidcrew/config.json." >&2
    exit 2 ;;
esac

exit 0
