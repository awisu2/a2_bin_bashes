#!/bin/bash
set -eu -o pipefail

# NOTE: not change directory. thiss
CURRENT_DIR="$(pwd)"
SELF_DIR=`cd "$(dirname "${BASH_SOURCE[0]}")" && pwd`

help() {
cat << EOF
Convert mp4 files to be compatible with browsers using ffmpeg.

Usage: $0 {Command} [args...]
  current-dir            : convert all moviee files in current directory.
  files [file1 file2 ...]: convert specified files and directories (recursively).
EOF
}

# load support files =====
source "$SELF_DIR/scripts/index.sh"

# set envs =====
ADD_SUFFIX="_browser"

# functions =====
get_output_name() {
  local _ADD_SUFFIX="${2:-_converted}"
  local name=`get_basename "$1"`
  local ext=`get_ext "$1"`
  echo "${name}${_ADD_SUFFIX}.${ext}"
}

convert_file() {
  local FILE="$1"
  local OUT=$(get_output_name "$FILE" "$ADD_SUFFIX")
  if [[ -f "$OUT" ]]; then
    echo "Output file $OUT already exists, skipping $FILE"
    return
  fi
  
  # TODO: more wide ext check
  local ext=`get_ext "$FILE"`
  if [[ "$ext" != "mp4" ]]; then
    echo "File $FILE is not an mp4 file, skipping. ext: $ext"
    return
  fi
  
  convert_for_browser "$FILE" "$OUT"
}

# Convert files with type check
convert_files() {
  local _FILES=("$@")
  local _FILE _SUBFILES _SUBFILE
  
  for _FILE in "${_FILES[@]}"; do
    if [[ -d "$_FILE" ]]; then
      
      while IFS= read -r -d '' _SUBFILE; do
        convert_file "$_SUBFILE"
      done < <(find "$_FILE" -type f -iname '*.mp4' -print0)
      continue
    fi
    
    if [[ -f "$_FILE" ]]; then
      convert_file "$_FILE"
    fi
  done
}

convert_current_dir() {
  convert_files "$CURRENT_DIR"
}

# main =====
[ $# -gt 0 ] && { COMMAND="$1"; shift; }
case "${COMMAND:-}" in
  current-dir)
    convert_current_dir
  ;;
  files)
    convert_files "$@"
  ;;
  separate_test)
    NAME=`get_basename "aaa/bb ccc.tst"`
    EXT=`get_ext "aaa/bb ccc.tst"`
    
    echo "name: $NAME, ext: $EXT"
  ;;
  *)
    help
    exit 1
  ;;
esac
