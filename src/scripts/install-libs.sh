#!/bin/bash

echo ""
echo ""
echo "Installing required libraries for contract checks..."
echo "******************************************************************************"
echo ""
echo ""

echo "Install GraphQL Inspector CLI tool..."
NPM_PACKAGE_NAME="@graphql-inspector/cli"
if ! npm list -g $NPM_PACKAGE_NAME --depth=0 >/dev/null 2>&1; then
  echo "GraphQL Inspector CLI not found, installing..."
  npm install -g $NPM_PACKAGE_NAME
else
  echo "GraphQL Inspector CLI already installed."
fi

echo "Download OpenAPI Diff CLI tool..."
JAR_PATH="./tools/openapi-diff-cli.jar"
mkdir -p tools
if [ -f "$JAR_PATH" ]; then
  echo "OpenAPI Diff CLI already downloaded."
  exit 0
else
  echo "Downloading OpenAPI Diff CLI..."
  curl -L https://repo1.maven.org/maven2/org/openapitools/openapidiff/openapi-diff-cli/2.1.7/openapi-diff-cli-2.1.7-all.jar \
          -o "$JAR_PATH"
fi

ls -la tools/

echo "Fetch prod branch..."
git fetch origin prod

exit 0