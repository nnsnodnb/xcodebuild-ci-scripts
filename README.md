# xcodebuild-ci-scripts

## Usage

```yaml
steps:
  - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
    with:
      repository: nnsnodnb/xcodebuild-ci-scripts
      path: ci_scripts
```

## Scripts

### create_keychain.sh

```bash
./ci_scripts/create_keychain.sh
```

### get_marketing_version.sh

```bash
./ci_scripts/get_marketing_version.sh \
  {{ YOUR_APP_NAME }} \
  {{ YOUR_SCHEME }}
```

### archive_export.sh

```bash
./ci_scripts/archive_export.sh \
  {{ YOUR_APP_NAME }} \
  {{ YOUR_SCHEME }} \
  {{ YOUR_VERSION }} \
  {{ YOUR_KEY_ID }} \
  {{ YOUR_ISSUER_ID }}
```

### firebase_distribution.sh

```bash
./ci_scripts/firebase_distribution.sh \
  {{ YOUR_SCHEME }} \
  {{ YOUR_FIREBASE_APP_ID }}
```

### upload_app_store_connect.sh

```bash
./ci_scripts/upload_app_store_connect.sh \
  {{ YOUR_APP_NAME }} \
  {{ YOUR_KEY_ID }} \
  {{ YOUR_ISSUER_ID }} \
  {{ YOUR_ASC_APP_ID }} \
  {{ YOUR_IPA_PATH }} \
  {{ YOUR_VERSION }}
```
