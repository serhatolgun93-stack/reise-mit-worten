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
  rm -f test/widget_test.dart
else
  echo "Android/iOS runners already exist."
fi

if [[ -f android/app/build.gradle.kts ]]; then
  python3 - <<'PY'
from pathlib import Path
p = Path('android/app/build.gradle.kts')
s = p.read_text(encoding='utf-8')
s = s.replace('compileSdk = flutter.compileSdkVersion', 'compileSdk = 37')
s = s.replace('applicationId = "com.example.reise_mit_worten"', 'applicationId = "de.reisemitworten.preview1"')
s = s.replace('namespace = "com.example.reise_mit_worten"', 'namespace = "de.reisemitworten.preview1"')
p.write_text(s, encoding='utf-8')
PY
fi

if [[ -f android/app/src/main/kotlin/com/example/reise_mit_worten/MainActivity.kt ]]; then
  mkdir -p android/app/src/main/kotlin/de/reisemitworten/preview1
  sed 's/^package com\.example\.reise_mit_worten/package de.reisemitworten.preview1/' \
    android/app/src/main/kotlin/com/example/reise_mit_worten/MainActivity.kt \
    > android/app/src/main/kotlin/de/reisemitworten/preview1/MainActivity.kt
  rm -rf android/app/src/main/kotlin/com
fi

if [[ -f android/app/src/main/AndroidManifest.xml ]]; then
  python3 - <<'PY'
from pathlib import Path
p = Path('android/app/src/main/AndroidManifest.xml')
s = p.read_text(encoding='utf-8')
s = s.replace('android:label="reise_mit_worten"', 'android:label="Reise mit Worten Preview"')
p.write_text(s, encoding='utf-8')
PY
fi

if [[ -f android/gradle.properties ]]; then
  grep -q '^android.suppressUnsupportedCompileSdk=37$' android/gradle.properties || \
    printf '\nandroid.suppressUnsupportedCompileSdk=37\n' >> android/gradle.properties
fi

if command -v sdkmanager >/dev/null 2>&1; then
  yes | sdkmanager --licenses >/dev/null 2>&1 || true
  sdkmanager 'platforms;android-37'
else
  echo "WARNING: sdkmanager not found; relying on the runner/Gradle Android SDK setup." >&2
fi
