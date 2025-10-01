# cntdwn

## Getting Started
### 1. Setup the project
execute : `sh ./scripts/setup.sh <new_project_name> <new_project_id> <new_app_name>`
    - example :`sh ./scripts/setup.sh meme_forge com.meme.forge "Meme Forge"`

### 2. Assets generation
Edit `assets_generation/AppTemplate.fig`
    - Export each individual icon assets in `assets_generation/icon`
    - Export each individual splash screen assets in `assets_generation/splash_screen`

Run `sh ./scripts/generate_launcher_icons.sh`
Run `sh ./scripts/generate_splash_screens.sh`

### Init firebase
Run `dart pub global activate flutterfire_cli`
Run `export PATH="$PATH":"$HOME/.pub-cache/bin"`
Run `flutterfire configure`
Make sur to enable firestore & firebase auth

### Deploy firestore rules
run `firebase init`
run `firebase deploy --only firestore:rules`

### Init firebase remote config
add string variable `min_app_version_ios` set to "1.0.0"
add string variable `min_app_version_android` set to "1.0.0"

### App Links
After registering your app on the play store and app store, you need to update the links in the code
- open `lib/core/texts/app_links.dart`
Replace androidAppStoreUrl with the link to your app on the play store
Replace iosAppStoreUrl with the link to your app on the app store

### Deploy app using fastlane
⚠️ First submission should be done manually
## 1. init fastlane in iOS project
// ⚠️ TEST -> Je ne sais pas si ça va override les fichiers fastlane existants -> vérifier que non
run `cd ios && fastlane init`
Update the `.env.template` file with your app store links en rename it to `.env`
Update the Fastfile `release_notes` to remove unused translations

## 2. init fastlane in Android project
Generate a new service account key by follwing this guide : https://docs.fastlane.tools/getting-started/android/setup/
Don't forget to invite the service account to the project on Play Console
Rename the file to `fastlane_service_account.json` and move it to the root of the Android project// ⚠️ TEST -> Je ne sais pas si ça va override les fichiers fastlane existants -> vérifier que non
run `cd android && fastlane init`

run `sh ./scripts/release_app.sh <x.x.x>` from the root of the project