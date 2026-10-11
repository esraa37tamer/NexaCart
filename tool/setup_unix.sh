#!/usr/bin/env bash
set -euo pipefail
flutter --version
flutter doctor
flutter pub get
PUB_CACHE_DIR="${PUB_CACHE:-$HOME/.pub-cache}"
REALM_GRADLE="$PUB_CACHE_DIR/hosted/pub.dev/realm-20.2.0/android/build.gradle"
if [[ ! -f "$REALM_GRADLE" ]]; then
  echo "Realm build.gradle not found: $REALM_GRADLE" >&2
  exit 1
fi
python3 -c "from pathlib import Path; import re; p=Path('$REALM_GRADLE'); s=p.read_text(); s=re.sub(r'compileSdkVersion\\s*(?:=\\s*)?31','compileSdkVersion 37',s); s=re.sub(r'compileSdk\\s*=\\s*31','compileSdk = 37',s); s=re.sub(r'compileSdk\\s+31','compileSdk 37',s); p.write_text(s)"
dart run realm install
dart run flutter_launcher_icons
dart run flutter_native_splash:create
flutter clean
flutter pub get
flutter analyze
echo "Setup complete. Run: flutter run"
