#!/bin/bash


VERSION=$(git describe --tags --abbrev=0)
COMMIT=$(git rev-parse HEAD)
BUILD_TIME=$(date -u +%Y-%m-%dT%H:%M:%SZ)
GO_VERSION=$(go version)
GOOS=$(go env GOOS)
GOARCH=$(go env GOARCH)
SERVICES=$(ls -d */ | cut -d'/' -f1)

echo "📊 Project Status"
echo "================"
echo "Version:     $VERSION"
echo "Commit:      $COMMIT"
echo "Build Time:  $BUILD_TIME"
echo "Go Version:  $GO_VERSION"
echo "Platform:    $GOOS/$GOARCH"
echo ""
if [ -n "$SERVICES" ]; then
  echo "Services:    $(echo $SERVICES | wc -w | tr -d ' ')"
fi
if command -v git >/dev/null 2>&1; then
  echo "Git Branch:  $(git branch --show-current 2>/dev/null || echo 'unknown')"
  echo "Git Status:  $(git status --porcelain | wc -l | tr -d ' ') changes"
fi