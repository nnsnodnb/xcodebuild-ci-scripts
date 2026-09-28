#!/bin/bash -eu

NAME="$1"
SCHEME="$2"
WORKSPACE="${NAME}.xcworkspace"

MARKETING_VERSION="$(xcodebuild \
  -showBuildSettings \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME}" \
  -clonedSourcePackagesDirPath .swiftpm \
  -disableAutomaticPackageResolution \
  | grep -m1 "MARKETING_VERSION" \
  | awk -F ' = ' '{print $2}' \
  | tr -d '[:space:]')"
echo "marketing_version=${MARKETING_VERSION}" >> "${GITHUB_OUTPUT}"
