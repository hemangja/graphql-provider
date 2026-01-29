#!/bin/bash

echo ""
echo ""
echo "******************************************************************************"
echo ""
echo ""

APPROVAL_TAG="\[BREAKING-APPROVED\]"
TMP_FILE=".git/openapi-breaking.tmp"
COMMIT_MSG_FILE=".git/COMMIT_EDITMSG"

# No breaking change → allow commit
if [ ! -f $TMP_FILE ]; then
  echo "✅ OpenAPI contract is backward compatible."
  exit 0
fi

# Commit message file MUST exist
if [ ! -f "$COMMIT_MSG_FILE" ]; then
  echo "⚠️ Cannot find commit message file. Blocking commit."
  exit 1
fi

# Breaking change detected → require approval
if grep -q "$APPROVAL_TAG" "$COMMIT_MSG_FILE"; then
  echo "⚠️ Breaking change approved via commit message."
  rm -f $TMP_FILE
  exit 0
fi

echo ""
echo "❌ Breaking OpenAPI contract change detected."
echo "Add [BREAKING-APPROVED] to commit message to proceed."
echo "Commit blocked."
exit 1
