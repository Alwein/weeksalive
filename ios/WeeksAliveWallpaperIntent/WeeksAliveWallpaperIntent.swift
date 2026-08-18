import AppIntents
import ExtensionFoundation

/// Lightweight App Intents extension entry point. Runs without launching the
/// Flutter host app so Shortcuts automations can read the wallpaper PNG from
/// the shared App Group within the system timeout budget.
@main
struct WeeksAliveWallpaperIntentExtension: AppIntentsExtension {}
