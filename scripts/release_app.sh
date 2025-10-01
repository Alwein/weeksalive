#!/bin/bash
# to use : sh ./scripts/release_app.sh <x.x.x>

set -euo pipefail

if [ -z "${1-}" ]; then
  echo "❌ Veuillez spécifier un numéro de version (ex: ./scripts/release_app.sh 3.24.2)"
  exit 1
fi

NEW_VERSION="$1"

CURRENT_BUILD=$(grep '^version:' pubspec.yaml | cut -d '+' -f2)
NEW_BUILD=$((CURRENT_BUILD + 1))

echo "🔄 Mise à jour de pubspec.yaml vers $NEW_VERSION+$NEW_BUILD"

sed -i '' "s/^version: .*/version: $NEW_VERSION+$NEW_BUILD/" pubspec.yaml

grep "^version:" pubspec.yaml

echo "🔧 Flutter pub get"
flutter pub get

echo "📌 Commit & Tag Git"
git add pubspec.yaml
git commit -m "🚀 Release $NEW_VERSION+$NEW_BUILD" || echo "ℹ️ Rien à committer ?"
git tag -a "v$NEW_VERSION" -m "Release $NEW_VERSION" || echo "ℹ️ Tag déjà existant ?"
git push origin main --tags

echo "🚀 Compilation et upload Android et iOS en parallèle..."

(
  echo "📦 Build Android (AAB)"
  flutter build appbundle &&
  cd android &&
  fastlane upload_aab
) &

(
  echo "🍏 Build iOS (IPA + TestFlight + soumission App Store)"
  flutter build ipa &&
  cd ios &&
  fastlane release_store
) &

wait

echo "✅ Déploiement terminé ! 🎉"
