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
  # flutter create adds a default MyApp widget test that does not belong to RMW.
  rm -f test/widget_test.dart
else
  echo "Android/iOS runners already exist."
fi

# permission_handler_android currently requires compileSdk 37.
# Keep targetSdk/minSdk managed by Flutter; only raise compileSdk.
if [[ -f android/app/build.gradle.kts ]]; then
  python3 - <<'PY'
from pathlib import Path
p = Path('android/app/build.gradle.kts')
s = p.read_text(encoding='utf-8')
s = s.replace('compileSdk = flutter.compileSdkVersion', 'compileSdk = 37')
p.write_text(s, encoding='utf-8')
PY
fi

# AGP 9.0.1 reports SDK 37 as newer than its recommended maximum (36),
# but compileSdk is backward compatible and required by the plugin metadata.
if [[ -f android/gradle.properties ]]; then
  grep -q '^android.suppressUnsupportedCompileSdk=37$' android/gradle.properties || \
    printf '\nandroid.suppressUnsupportedCompileSdk=37\n' >> android/gradle.properties
fi

# Ensure the required Android platform is installed on GitHub-hosted runners.
if command -v sdkmanager >/dev/null 2>&1; then
  yes | sdkmanager --licenses >/dev/null 2>&1 || true
  sdkmanager 'platforms;android-37'
else
  echo "WARNING: sdkmanager not found; relying on the runner/Gradle Android SDK setup." >&2
fi
