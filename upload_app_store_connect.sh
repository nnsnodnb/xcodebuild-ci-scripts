#!/bin/bash -eu

NAME="$1"
KEY_ID="$2"
ISSUER_ID="$3"
APP_ID="$4"
IPA_PATH="$5"
VERSION="$6"

brew install asc

asc auth login \
  --name "${NAME}" \
  --key-id "${KEY_ID}" \
  --issuer-id "${ISSUER_ID}" \
  --private-key /tmp/AuthKey.p8 \
  --network

asc auth status --validate
asc auth doctor

asc publish appstore \
  --app "${APP_ID}" \
  --ipa "${IPA_PATH}" \
  --version "${VERSION}"

asc status --app "${APP_ID}"
