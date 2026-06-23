package com.weeksalive

import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AppIconPlugin : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "supportsAlternateIcons" -> result.success(true)
            "setAlternateIconName" -> setAlternateIconName(call, result)
            else -> result.notImplemented()
        }
    }

    private fun setAlternateIconName(call: MethodCall, result: MethodChannel.Result) {
        val iconName = call.argument<String>("iconName")
        val activity = MainActivityHolder.activity
        val packageManager = activity.packageManager
        val packageName = activity.packageName
        val targetAlias = resolveTargetAlias(iconName, packageManager, packageName)

        for (alias in ALIASES) {
            val component = ComponentName(packageName, alias)
            val state = if (alias == targetAlias) {
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            } else {
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            }
            packageManager.setComponentEnabledSetting(
                component,
                state,
                PackageManager.DONT_KILL_APP,
            )
        }

        result.success(null)
    }

    private fun resolveTargetAlias(
        iconName: String?,
        packageManager: PackageManager,
        packageName: String,
    ): String? {
        return when (iconName) {
            "dark" -> "$PACKAGE_NAME.AppIconDark"
            "draw" -> "$PACKAGE_NAME.AppIconDraw"
            "outline" -> "$PACKAGE_NAME.AppIconOutline"
            "sisyphus" -> "$PACKAGE_NAME.AppIconSisyphus"
            "gold" -> "$PACKAGE_NAME.AppIconGold"
            else -> if (usesMainActivityLauncher(packageManager, packageName)) {
                null
            } else {
                "$PACKAGE_NAME.AppIconComposer"
            }
        }
    }

    private fun usesMainActivityLauncher(
        packageManager: PackageManager,
        packageName: String,
    ): Boolean {
        val intent = Intent(Intent.ACTION_MAIN)
            .addCategory(Intent.CATEGORY_LAUNCHER)
            .setPackage(packageName)
        return packageManager.queryIntentActivities(intent, PackageManager.MATCH_ALL).any { resolveInfo ->
            resolveInfo.activityInfo.name == "$PACKAGE_NAME.MainActivity"
        }
    }

    companion object {
        private const val PACKAGE_NAME = "com.weeksalive"
        const val CHANNEL = "com.weeksalive/app_icon"

        private val ALIASES = listOf(
            "$PACKAGE_NAME.AppIconComposer",
            "$PACKAGE_NAME.AppIconDark",
            "$PACKAGE_NAME.AppIconDraw",
            "$PACKAGE_NAME.AppIconOutline",
            "$PACKAGE_NAME.AppIconSisyphus",
            "$PACKAGE_NAME.AppIconGold",
        )

        fun register(flutterEngine: FlutterEngine) {
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler(AppIconPlugin())
        }
    }
}
