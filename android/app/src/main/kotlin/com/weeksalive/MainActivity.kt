package com.weeksalive

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MainActivityHolder.init(this)
        WallpaperPlugin.register(flutterEngine)
        AppIconPlugin.register(flutterEngine)
    }
}
