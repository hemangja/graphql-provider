#!/bin/bash

echo "Checking GraphQL contract compatibility..."

BASELINE_SCHEMA="src/contracts/product-released.graphqls"
CURRENT_SCHEMA="src/main/resources/graphql/product-current.graphqls"
TMP_FILE=".git/graphql-breaking.tmp"

git show origin/prod:$CURRENT_SCHEMA > $BASELINE_SCHEMA

if [ ! -f "$BASELINE_SCHEMA" ]; then
  echo "Baseline schema not found. Skipping check."
  exit 0
fi

graphql-inspector diff \
  "$BASELINE_SCHEMA" \
  "$CURRENT_SCHEMA"

RESULT=$?

rm -f "$BASELINE_SCHEMA"

if [ $RESULT -ne 0 ]; then
  echo "breaking" > "$TMP_FILE"
  echo ""
  echo "❌ Breaking GraphQL contract changes detected."
  echo "Commit blocked."
  exit 1
else
  rm -f "$TMP_FILE"
fi

echo "✅ GraphQL contract is backward compatible."
exit 0