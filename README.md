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
NEXT: Implémenter la logique de base 
- main
- init app
- Login anonimously
- Get user in bootsrap bloc
- Initial tests