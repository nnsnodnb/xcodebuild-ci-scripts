#!/bin/bash -eu

SCHEME="$1"
APP_ID="$2"
PRODUCTS_PATH="$(pwd)/Products"
RELEASE_NOTE="$(git log -n 5 --format='%h %s' --no-merges)"

npx --yes \
  firebase-tools appdistribution:distribute \
    ${PRODUCTS_PATH}/${SCHEME}.ipa \
    --app ${APP_ID} \
    --groups owner \
    --release-notes "${RELEASE_NOTE}"
