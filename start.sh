#!/usr/bin/env bash
set -euo pipefail

# Parse flags
USE_TMUX=false
SESSION_NAME="speaker-view"
TALK_SESSION="talk"
OUTPUT="eDP-1"

# Run from the script directory, so relative paths work from anywhere
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SLIDES="$ROOT/public/tmux-is-love.md"

error() { echo "error: $*" >&2; }
warn()  { echo "warning: $*" >&2; }

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -t, --tmux         Force tmux mode (auto-detected if inside a tmux session)
  -o, --output NAME  Screen to mirror and display keys onto (default: $OUTPUT)
  -n, --name NAME    tmux session name (default: $SESSION_NAME)
  -h, --help         Show this help
EOF
    exit 0
}
while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--tmux)        USE_TMUX=true; shift ;;
        -o|--output)
            [[ $# -ge 2 ]] || { error "$1 needs a value"; exit 1; }
            OUTPUT="$2"; shift 2 ;;
        -n|--name)
            [[ $# -ge 2 ]] || { error "$1 needs a value"; exit 1; }
            SESSION_NAME="$2"; shift 2 ;;
        -h|--help)        usage ;;
        *)                error "Unknown option: $1"; usage ;;
    esac
done

# Auto-detect tmux: if we're already in a tmux session, use tmux mode
if [[ -n "${TMUX:-}" ]] && command -v tmux &>/dev/null; then
    USE_TMUX=true
fi

# Create a detached tmux session running a command, unless it already exists
# Usage: ensure_session NAME COMMAND
ensure_session() {
    local name="$1" cmd="$2"
    if tmux has-session -t "=$name" 2>/dev/null; then
        warn "tmux session '$name' already exists, reusing it"
    else
        tmux new-session -d -s "$name" -c "$ROOT" "$cmd"
    fi
}

# tmux mode
start_tmux() {
  # "talk" session: the slides, publishing the speaker notes
  ensure_session "$TALK_SESSION" "presenterm --publish-speaker-notes '$SLIDES'"
  echo "Slides are in tmux session '$TALK_SESSION' (tmux attach -t $TALK_SESSION)"

  # Speaker view session: the speaker notes
  ensure_session "$SESSION_NAME" "presenterm --listen-speaker-notes '$SLIDES'"

  # GUI tools run in the background
  local showkeys_opts=(-t 2 -p 5 -a top -m 5)
  if [[ -n "$OUTPUT" ]]; then
    wl-showkeys "${showkeys_opts[@]}" -o "$OUTPUT" &
    wl-mirror "$OUTPUT" &
  else
    warn "no output set: wl-showkeys uses its default screen, wl-mirror is skipped"
    wl-showkeys "${showkeys_opts[@]}" &
  fi

  # Show the speaker view
  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "=$SESSION_NAME"
  else
    tmux attach-session -t "=$SESSION_NAME"
  fi
}

# Main
if [[ "$USE_TMUX" == true ]]; then
    if ! command -v tmux &>/dev/null; then
        error "tmux requested but not installed"
        exit 1
    fi
    start_tmux
else
    if command -v tmux &>/dev/null; then
        warn "tmux detected, run with -t/--tmux for a better experience"
    fi
    start_plain
fi
