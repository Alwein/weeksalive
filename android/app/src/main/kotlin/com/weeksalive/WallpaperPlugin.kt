package com.weeksalive

import android.app.WallpaperManager
import android.graphics.BitmapFactory
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class WallpaperPlugin : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setWallpaper" -> setWallpaper(call, result)
            "openShortcuts" -> result.success(false)
            else -> result.notImplemented()
        }
    }

    private fun setWallpaper(call: MethodCall, result: MethodChannel.Result) {
        val path = call.argument<String>("path")
        if (path.isNullOrBlank()) {
            result.success(false)
            return
        }

        val file = File(path)
        if (!file.exists()) {
            result.success(false)
            return
        }

        try {
            val bitmap = BitmapFactory.decodeFile(file.absolutePath)
            if (bitmap == null) {
                result.success(false)
                return
            }

            val target = call.argument<String>("target") ?: "both"
            val which = when (target) {
                "home" -> WallpaperManager.FLAG_SYSTEM
                "lock" -> WallpaperManager.FLAG_LOCK
                else -> WallpaperManager.FLAG_SYSTEM or WallpaperManager.FLAG_LOCK
            }

            val manager = WallpaperManager.getInstance(MainActivityHolder.activity)
            manager.setBitmap(bitmap, null, true, which)

            val gridType = call.argument<String>("gridType")
            if (gridType != null) {
                WallpaperScheduler.schedule(MainActivityHolder.activity, gridType)
            }

            result.success(true)
        } catch (_: Exception) {
            result.success(false)
        }
    }

    companion object {
        const val CHANNEL = "com.weeksalive/wallpaper"

        fun register(flutterEngine: FlutterEngine) {
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler(WallpaperPlugin())
        }
    }
}

/// Holds the current [MainActivity] reference for [WallpaperManager] calls.
object MainActivityHolder {
    lateinit var activity: MainActivity
        private set

    fun init(activity: MainActivity) {
        this.activity = activity
    }
}
