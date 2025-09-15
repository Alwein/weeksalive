#!/bin/bash

# Check arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <new_project_name> <new_project_id> <new_app_name>"
    exit 1
fi

NEW_PROJECT_NAME=$1
NEW_PROJECT_ID=$2
NEW_APP_NAME=$3

OLD_PROJECT_NAME="flutter_fast_template"
OLD_PROJECT_ID="com.example.flutter_fast_template"

# 1. Update pubspec.yaml
sed -i '' "s/name: .*/name: $NEW_PROJECT_NAME/" pubspec.yaml

# 2. Update Android app ID and files
ANDROID_PATH="android/app"

# AndroidManifest.xml
find "$ANDROID_PATH" -type f -name "AndroidManifest.xml" -exec sed -i '' "s/$OLD_PROJECT_ID/$NEW_PROJECT_ID/g" {} +
find "$ANDROID_PATH" -type f -name "AndroidManifest.xml" -exec sed -i '' "s/android:label=\".*\"/android:label=\"$NEW_APP_NAME\"/g" {} +

# build.gradle
sed -i '' "s/^\([[:space:]]*applicationId[[:space:]]*=[[:space:]]*\)\".*\"/\1\"$NEW_PROJECT_ID\"/g" "$ANDROID_PATH/build.gradle"
sed -i '' "s/namespace = \".*\"/namespace = \"$NEW_PROJECT_ID\"/" "$ANDROID_PATH/build.gradle"

# strings.xml
sed -i '' "s/<string name=\"app_name\">.*<\/string>/<string name=\"app_name\">$NEW_APP_NAME<\/string>/" "$ANDROID_PATH/src/main/res/values/strings.xml"

# Fix Kotlin package structure
OLD_ANDROID_PACKAGE_PATH=$(echo "$OLD_PROJECT_ID" | tr '.' '/')
NEW_ANDROID_PACKAGE_PATH=$(echo "$NEW_PROJECT_ID" | tr '.' '/')

ANDROID_MAIN_PATH="android/app/src/main/kotlin"

mkdir -p "$ANDROID_MAIN_PATH/$NEW_ANDROID_PACKAGE_PATH"
mv "$ANDROID_MAIN_PATH/$OLD_ANDROID_PACKAGE_PATH/MainActivity.kt" "$ANDROID_MAIN_PATH/$NEW_ANDROID_PACKAGE_PATH/MainActivity.kt"
sed -i '' "s/package $OLD_PROJECT_ID/package $NEW_PROJECT_ID/" "$ANDROID_MAIN_PATH/$NEW_ANDROID_PACKAGE_PATH/MainActivity.kt"
rm -rf "$ANDROID_MAIN_PATH/com/example"

# 3. Update iOS app ID
IOS_PATH="ios"

# Update bundle identifier in project.pbxproj
find "$IOS_PATH" -name "project.pbxproj" -exec sed -i '' "s/$OLD_PROJECT_ID/$NEW_PROJECT_ID/g" {} +
find "$IOS_PATH" -name "project.pbxproj" -exec sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = .*;/PRODUCT_BUNDLE_IDENTIFIER = $NEW_PROJECT_ID;/g" {} +

# Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleName \"$NEW_APP_NAME\"" "$IOS_PATH/Runner/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName \"$NEW_APP_NAME\"" "$IOS_PATH/Runner/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier \"$NEW_PROJECT_ID\"" "$IOS_PATH/Runner/Info.plist"


# 4. Update global project name in all files (before renaming directory)
echo "🔄 Replacing project name references..."

# Replace flutter_fast_template in all Dart files and other text files
find . -type f \( -name "*.dart" -o -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.md" -o -name "*.txt" -o -name "*.xml" -o -name "*.plist" -o -name "*.kt" -o -name "*.swift" \) -not -path './.git/*' -exec sed -i '' "s/$OLD_PROJECT_NAME/$NEW_PROJECT_NAME/g" {} +

# Replace "Flutter Fast Template" by new app name
find . -type f \( -name "*.dart" -o -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.md" -o -name "*.txt" -o -name "*.xml" -o -name "*.plist" -o -name "*.kt" -o -name "*.swift" \) -not -path './.git/*' -exec sed -i '' "s/Flutter Fast Template/$NEW_APP_NAME/g" {} +

# Additional specific replacements for Dart imports
echo "📦 Updating Dart package imports..."
find . -name "*.dart" -not -path './.git/*' -exec sed -i '' "s/package:$OLD_PROJECT_NAME/package:$NEW_PROJECT_NAME/g" {} +

# 5. Rename project directory if needed
echo "📁 Renaming project directory..."
cd ..
mv "$OLD_PROJECT_NAME" "$NEW_PROJECT_NAME"
cd "$NEW_PROJECT_NAME"

# 6. Final verification and cleanup
echo "🔍 Final verification of replacements..."

# Double-check that all flutter_fast_template references are replaced
REMAINING_REFERENCES=$(grep -r "flutter_fast_template" . --exclude-dir=.git --exclude="setup.sh" 2>/dev/null | wc -l)
if [ "$REMAINING_REFERENCES" -gt 0 ]; then
    echo "⚠️  Warning: $REMAINING_REFERENCES references to 'flutter_fast_template' still found"
    echo "   This might be expected in some configuration files"
fi

# 7. Clean up git history and reinitialize
rm -rf .git
git init
git add .
git commit -m "🎉 Initial commit - from template"

# 8. Clean up and get dependencies
echo "🧹 Cleaning and getting dependencies..."
flutter clean
flutter pub get

# Done
echo "✅ Project setup completed! 🚀"
echo "📱 Your new project '$NEW_PROJECT_NAME' is ready to use!"
