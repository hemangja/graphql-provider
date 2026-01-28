#!/bin/bash

echo "Checking GraphQL contract compatibility..."

BASELINE_SCHEMA="src/contracts/product-released.graphqls"
CURRENT_SCHEMA="src/main/resources/graphql/product-current.graphqls"

git show origin/prod:$CURRENT_SCHEMA > $BASELINE_SCHEMA

if [ ! -f "$BASELINE_SCHEMA" ]; then
  echo "Baseline schema not found. Skipping check."
  exit 0
fi

graphql-inspector diff \
  "$BASELINE_SCHEMA" \
  "$CURRENT_SCHEMA"

RESULT=$?

rm src/contracts/product-released.graphqls

# Store result for commit-msg hook
if [ $RESULT -ne 0 ]; then
  echo "breaking" > .git/graphql-breaking.tmp
else
  rm -f .git/graphql-breaking.tmp
fi

exit 0