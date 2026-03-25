#!/bin/sh
# PreToolUse hook — block if Claude has been running > 10 min without user input
THRESHOLD=600
_SESSION=$(tty 2>/dev/null | tr '/' '_' | sed 's/^_//')
LAST_ACTIVITY_FILE="/tmp/claude-aligned-last-user-activity-${_SESSION}.txt"
EXCEPTION_FILE="/tmp/claude-aligned-long-running-exception-${_SESSION}.txt"
NOW=$(date -u +%s)

# Check for an active exception window
if [ -f "$EXCEPTION_FILE" ]; then
  EXPIRY=$(cat "$EXCEPTION_FILE")
  if [ "$NOW" -lt "$EXPIRY" ]; then
    exit 0
  fi
  rm -f "$EXCEPTION_FILE"
fi

# No last-activity file means session just started — let it through
[ -f "$LAST_ACTIVITY_FILE" ] || exit 0

LAST=$(cat "$LAST_ACTIVITY_FILE")
ELAPSED=$((NOW - LAST))

if [ "$ELAPSED" -gt "$THRESHOLD" ]; then
  MINUTES=$((ELAPSED / 60))
  cat << EOF
{
  "decision": "block",
  "reason": "Auto-pause: ${MINUTES} minutes have passed since the last user message. Invoke the auto-pause skill: summarize what you have done, state where you are, say what you were about to do next, and wait for user input. If this was a legitimate long-running operation, set an exception before starting next time (see auto-pause skill)."
}
EOF
fi
