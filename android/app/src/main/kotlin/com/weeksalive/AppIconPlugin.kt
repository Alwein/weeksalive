package com.weeksalive

import android.content.ComponentName
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
        val targetAlias = resolveTargetAlias(iconName)

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

    private fun resolveTargetAlias(iconName: String?): String {
        return when (iconName) {
            "composer_outline" -> "$PACKAGE_NAME.AppIconComposerOutline"
            "composer_outline_light" -> "$PACKAGE_NAME.AppIconComposerOutlineLight"
            "draw" -> "$PACKAGE_NAME.AppIconDraw"
            "composer_outline_silver" -> "$PACKAGE_NAME.AppIconComposerOutlineSilver"
            "sisyphus" -> "$PACKAGE_NAME.AppIconSisyphus"
            "composer_outline_gold" -> "$PACKAGE_NAME.AppIconComposerOutlineGold"
            else -> "$PACKAGE_NAME.AppIconComposerOutline"
        }
    }

    companion object {
        private const val PACKAGE_NAME = "com.weeksalive"
        const val CHANNEL = "com.weeksalive/app_icon"

        private val ALIASES = listOf(
            "$PACKAGE_NAME.AppIconComposerOutline",
            "$PACKAGE_NAME.AppIconComposerOutlineLight",
            "$PACKAGE_NAME.AppIconDraw",
            "$PACKAGE_NAME.AppIconComposerOutlineSilver",
            "$PACKAGE_NAME.AppIconSisyphus",
            "$PACKAGE_NAME.AppIconComposerOutlineGold",
        )

        fun register(flutterEngine: FlutterEngine) {
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler(AppIconPlugin())
        }
    }
}
