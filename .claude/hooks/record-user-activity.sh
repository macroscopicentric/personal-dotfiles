#!/bin/sh
# UserPromptSubmit hook — record timestamp of last user message
_SESSION=$(tty 2>/dev/null | tr '/' '_' | sed 's/^_//')
date -u +%s > "/tmp/claude-aligned-last-user-activity-${_SESSION}.txt"
echo '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit"}}'
