#!/bin/bash

echo ""
echo ""
echo "******************************************************************************"
echo ""
echo ""

TMP_FILE=".git/openapi-breaking.tmp"

# No breaking change → allow commit
if [ ! -f $TMP_FILE ]; then
  echo "✅ OpenAPI contract is backward compatible."
  exit 0
fi

# Breaking change detected → require approval
# (Example using environment variable)
# Ensure PR_LABELS is defined (default empty if not provided)
PR_LABELS="${PR_LABELS:-}"
echo "PR_LABELS: $PR_LABELS"

case "$PR_LABELS" in
  *approved-breaking-change*)
    echo "Breaking OpenAPI contract change approved via PR label."
    rm -f "$TMP_FILE"
    exit 0
    ;;
esac

echo ""
echo "❌ Breaking OpenAPI contract change detected."
echo "❌ Missing required PR label: approved-breaking-change"
echo "PR merging blocked."

exit 1
