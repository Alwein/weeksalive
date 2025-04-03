# flutter_fast_template

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
// TODO: initialize app
Make sur to enable firestore & firebase auth

### Init firebase remote config
add string variable `min_app_version_ios` set to "1.0.0"
add string variable `min_app_version_android` set to "1.0.0"

### App Links
After registering your app on the play store and app store, you need to update the links in the code
- open `lib/core/texts/app_links.dart`
Replace androidAppStoreUrl with the link to your app on the play store
Replace iosAppStoreUrl with the link to your app on the app store