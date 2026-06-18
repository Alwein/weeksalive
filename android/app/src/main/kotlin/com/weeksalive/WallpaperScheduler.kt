package com.weeksalive

import android.content.Context
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit

/// Schedules [WallpaperWorker] to re-apply the cached wallpaper PNG on a
/// cadence that matches the active grid type.
object WallpaperScheduler {
    private const val WORK_NAME_YEAR = "weeksalive_wallpaper_year"
    private const val WORK_NAME_LIFE = "weeksalive_wallpaper_life"

    fun cancel(context: Context) {
        val workManager = WorkManager.getInstance(context)
        workManager.cancelUniqueWork(WORK_NAME_YEAR)
        workManager.cancelUniqueWork(WORK_NAME_LIFE)
    }

    fun schedule(context: Context, gridType: String) {
        val workManager = WorkManager.getInstance(context)
        cancel(context)

        val (name, intervalDays) = when (gridType) {
            "year" -> WORK_NAME_YEAR to 1L
            else -> WORK_NAME_LIFE to 7L
        }

        val request = PeriodicWorkRequestBuilder<WallpaperWorker>(intervalDays, TimeUnit.DAYS)
            .build()

        workManager.enqueueUniquePeriodicWork(
            name,
            ExistingPeriodicWorkPolicy.UPDATE,
            request,
        )
    }
}
