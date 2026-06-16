package com.weeksalive

import android.app.WallpaperManager
import android.content.Context
import android.graphics.BitmapFactory
import androidx.work.Worker
import androidx.work.WorkerParameters
import java.io.File

/// Re-applies the most recently rendered wallpaper PNG (cached by the Flutter
/// side in the app documents/files dir) so the live wallpaper stays current
/// without launching the app. Scheduled periodically by [WallpaperScheduler]:
/// daily for the year grid, weekly for the life grid.
class WallpaperWorker(
    context: Context,
    params: WorkerParameters,
) : Worker(context, params) {

    override fun doWork(): Result {
        return try {
            val file = wallpaperFile(applicationContext)
            if (!file.exists()) return Result.success()

            val bitmap = BitmapFactory.decodeFile(file.absolutePath) ?: return Result.retry()
            val manager = WallpaperManager.getInstance(applicationContext)
            val which = WallpaperManager.FLAG_SYSTEM or WallpaperManager.FLAG_LOCK
            manager.setBitmap(bitmap, null, true, which)
            Result.success()
        } catch (_: Exception) {
            Result.retry()
        }
    }

    companion object {
        /// Must match [WallpaperRenderer.wallpaperFileName] on the Flutter side.
        const val WALLPAPER_FILE_NAME = "weeksalive_wallpaper.png"

        fun wallpaperFile(context: Context): File {
            // path_provider's getApplicationDocumentsDirectory() maps to
            // context.getDir("flutter", MODE_PRIVATE) on Android.
            val dir = context.getDir("flutter", Context.MODE_PRIVATE)
            return File(dir, WALLPAPER_FILE_NAME)
        }
    }
}
