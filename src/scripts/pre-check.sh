#!/bin/bash

echo "Checking GraphQL contract compatibility..."

git show origin/prod:src/contracts/product-released.graphqls > src/contracts/product-released.graphqls

BASELINE_SCHEMA="src/contracts/product-released.graphqls"
CURRENT_SCHEMA="src/main/resources/graphql/product-current.graphqls"

if [ ! -f "$BASELINE_SCHEMA" ]; then
  echo "Baseline schema not found. Skipping check."
  exit 0
fi

graphql-inspector diff \
  "$BASELINE_SCHEMA" \
  "$CURRENT_SCHEMA"

RESULT=$?

rm src/contracts/product-released.graphqls

if [ $	 -ne 0 ]; then
  echo ""
  echo "❌ Breaking GraphQL contract changes detected."
  echo "Commit blocked."
  exit 1
fi

echo "✅ GraphQL contract is backward compatible."
exit 0