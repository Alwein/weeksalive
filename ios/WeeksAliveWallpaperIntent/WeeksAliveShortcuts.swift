import AppIntents

struct WeeksAliveShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: GetWallpaperIntent(),
            phrases: [
                "Get wallpaper from \(.applicationName)",
                "Get my \(.applicationName) wallpaper",
            ],
            shortTitle: "Get Wallpaper",
            systemImageName: "photo"
        )
    }
}
