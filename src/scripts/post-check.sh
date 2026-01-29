#!/bin/bash

TMP_FILE=".git/graphql-breaking.tmp"

# No breaking change → allow commit
if [ ! -f $TMP_FILE ]; then
  echo "✅ GraphQL contract is backward compatible."
  exit 0
fi

# Breaking change detected → require approval
# (Example using environment variable)
case "$PR_LABELS" in
  *approved-breaking-change*)
    echo "Breaking change approved via PR label."
    rm -f "$TMP_FILE"
    exit 0
    ;;
esac

echo ""
echo "❌ Breaking GraphQL contract change detected."
echo "❌ Missing required PR label: approved-breaking-change"
echo "PR merging blocked."
exit 1
