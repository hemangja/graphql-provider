#!/bin/bash

COMMIT_MSG_FILE=$1
APPROVAL_TAG="\[BREAKING-APPROVED\]"

# No breaking change → allow commit
if [ ! -f .git/graphql-breaking.tmp ]; then
  echo "✅ GraphQL contract is backward compatible."
  exit 0
fi

# Breaking change detected → require approval
if grep -q "$APPROVAL_TAG" "$COMMIT_MSG_FILE"; then
  echo "⚠️ Breaking change approved via commit message."
  rm -f .git/graphql-breaking.tmp
  exit 0
fi

echo ""
echo "❌ Breaking GraphQL contract change detected."
echo "Add [BREAKING-APPROVED] to commit message to proceed."
echo "Commit blocked."
exit 1
