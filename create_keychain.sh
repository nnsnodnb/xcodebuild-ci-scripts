#!/usr/bin/env bash
set -euo pipefail

if [ "${RUNNER_DEBUG}" = "1" ] ; then
  set -x
fi

security create-keychain -p "" runner.keychain
security default-keychain -s runner.keychain
security unlock-keychain -p "" runner.keychain
security set-keychain-settings -t 3600 -u runner.keychain
