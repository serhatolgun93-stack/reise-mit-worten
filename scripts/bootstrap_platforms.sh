#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: flutter SDK is not installed or not on PATH." >&2
  exit 2
fi
if [[ ! -d android || ! -d ios ]]; then
  echo "Generating missing Android/iOS Flutter runners..."
  cp pubspec.yaml pubspec.yaml.before_flutter_create
  flutter create --project-name reise_mit_worten --platforms=android,ios .
  if ! cmp -s pubspec.yaml pubspec.yaml.before_flutter_create; then
    echo "NOTE: flutter create changed pubspec.yaml. Review the diff before committing."
  fi
  rm -f pubspec.yaml.before_flutter_create
else
  echo "Android/iOS runners already exist."
fi
