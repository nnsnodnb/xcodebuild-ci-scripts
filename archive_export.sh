#!/bin/bash -eu

NAME="$1"
SCHEME="$2"
VERSION="$3"
KEY_ID="$4"
ISSUER_ID="$5"
GSP="$6"
WORKSPACE="${NAME}.xcworkspace"
PRODUCTS_PATH="$(pwd)/Products"
ARCHIVE_PATH="${PRODUCTS_PATH}/${SCHEME}.xcarchive"
AUTH_KEY_PATH="${HOME}/.appstoreconnect/private_keys/AuthKey_${KEY_ID}.p8"
DSYM_ZIP_PATH="${PRODUCTS_PATH}/${SCHEME}.app.dSYM.zip"

if [[ "${SCHEME}" = "AdHoc" ]]; then
  EXPORT_OPTION_PLIST="$(pwd)/ci_scripts/release_testing.plist"
  SHORT_HASH="$(git rev-parse --short HEAD)"
  MARKETING_VERSION="${VERSION}-${SHORT_HASH}"
elif [[ "${SCHEME}" = "Production" ]]; then
  EXPORT_OPTION_PLIST="$(pwd)/ci_scripts/app-store-connect.plist"
  MARKETING_VERSION="${VERSION}"
else
  echo "Invalid SCHEME"
  exit 1
fi

# Resolve dependencies packages
xcodebuild \
  -resolvePackageDependencies \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME}" \
  -configuration Release \
  -clonedSourcePackagesDirPath .swiftpm \
  -disableAutomaticPackageResolution

# Archive
mkdir -p "${PRODUCTS_PATH}"
set -o pipefail && \
  xcodebuild \
    -workspace "${WORKSPACE}" \
    -scheme "${SCHEME}" \
    -clonedSourcePackagesDirPath .swiftpm \
    -disableAutomaticPackageResolution \
    -destination 'generic/platform=iOS' \
    -archivePath "${ARCHIVE_PATH}" \
    -allowProvisioningUpdates \
    -authenticationKeyPath "${AUTH_KEY_PATH}" \
    -authenticationKeyID "${KEY_ID}" \
    -authenticationKeyIssuerID "${ISSUER_ID}" \
    MARKETING_VERSION="${MARKETING_VERSION}" \
    clean archive | tee "${PRODUCTS_PATH}/${SCHEME}.log" | xcbeautify

# Export
/usr/bin/xcrun \
  xcodebuild \
    -exportArchive \
    -exportOptionsPlist "${EXPORT_OPTION_PLIST}" \
    -archivePath "${ARCHIVE_PATH}" \
    -exportPath "${PRODUCTS_PATH}" \
    -allowProvisioningUpdates \
    -authenticationKeyPath "${AUTH_KEY_PATH}" \
    -authenticationKeyID "${KEY_ID}" \
    -authenticationKeyIssuerID "${ISSUER_ID}" \
    MARKETING_VERSION="${MARKETING_VERSION}"

# Upload dSYMs
cd "${ARCHIVE_PATH}/dSYMs" && \
  zip -r "${DSYM_ZIP_PATH}" ./*.dSYM && \
  cd -

UPLOAD_SYMBOLS_BIN=".swiftpm/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols"
if [[ -f "${UPLOAD_SYMBOLS_BIN}" ]]; then
  "${UPLOAD_SYMBOLS_BIN}" "${DSYM_ZIP_PATH}" \
    -gsp "${GSP}" \
    -p ios
fi
