#!/bin/bash -eu

NAME="$1"
KEY_ID="$2"
ISSUER_ID="$3"
APP_ID="$4"
IPA_PATH="$5"
VERSION="$6"
OPTIONAL_ARG="${7:-}"
AUTH_KEY_PATH="${HOME}/.appstoreconnect/private_keys/AuthKey_${KEY_ID}.p8"

OPTIONAL_ARGS=()
if [[ -n "$OPTIONAL_ARG" ]]; then
  OPTIONAL_ARGS+=("$OPTIONAL_ARG")
fi

brew install asc

asc auth login \
  --name "${NAME}" \
  --key-id "${KEY_ID}" \
  --issuer-id "${ISSUER_ID}" \
  --private-key "${AUTH_KEY_PATH}" \
  --network

asc auth status --validate --output table
asc auth doctor

asc publish appstore \
  --app "${APP_ID}" \
  --ipa "${IPA_PATH}" \
  --version "${VERSION}" \
  --output table \
  "${OPTIONAL_ARGS[@]}"

asc status \
  --app "${APP_ID}" \
  --output table
