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