#!/bin/bash

echo ""
echo ""
echo "******************************************************************************"
echo ""
echo ""

echo "Checking OpenAPI contract compatibility..."

BASELINE_SCHEMA="src/contracts/product-released.yml"
CURRENT_SCHEMA="src/main/resources/openapi/product-current.yml"
TMP_FILE=".git/openapi-breaking.tmp"

git show origin/prod:$CURRENT_SCHEMA > $BASELINE_SCHEMA

if [ ! -f "$BASELINE_SCHEMA" ]; then
  echo "Baseline schema not found. Skipping check."
  exit 0
fi

java -jar tools/openapi-diff-cli.jar \
  --fail-on-incompatible \
  "$BASELINE_SCHEMA" \
  "$CURRENT_SCHEMA"

RESULT=$?

rm -f "$BASELINE_SCHEMA"

if [ $RESULT -ne 0 ]; then
  echo "breaking" > "$TMP_FILE"
else
  rm -f "$TMP_FILE"
fi

exit 0