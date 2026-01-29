#!/bin/bash

echo "Install GraphQL Inspector CLI tool..."
npm install -g @graphql-inspector/cli

echo "Download OpenAPI Diff CLI tool..."
mkdir -p tools
curl -L https://repo1.maven.org/maven2/org/openapitools/openapidiff/openapi-diff-cli/2.1.7/openapi-diff-cli-2.1.7-all.jar \
          -o tools/openapi-diff-cli.jar
ls -la tools/

echo "Fetch prod branch..."
git fetch origin prod

exit 0