#!/bin/bash
# PreToolUse hook: block terraform/tofu subcommands that touch state or AWS.
# Exit code 2 blocks the Bash call and sends stderr back to Claude.

# Fail closed: without jq we can't read the command, so block everything
if ! command -v jq >/dev/null 2>&1; then
  echo "block-terraform hook: jq not found, blocking command" >&2
  exit 2
fi

# Read the command and flatten newlines so "terraform \<newline> plan" is caught
cmd=$(jq -r '.tool_input.command // empty' | tr '\n' ' ')

pattern='(^|[^[:alnum:]_.-])(terraform|tofu)[[:space:]](.*[[:space:]])?(init|plan|apply|destroy|import|state|refresh)([[:space:]]|$)'

if printf '%s' "$cmd" | grep -Eq "$pattern"; then
  echo "Blocked by hook: terraform/tofu init/plan/apply/destroy/import/state/refresh are not allowed. Ask the user to run it with '!'." >&2
  exit 2
fi

exit 0
