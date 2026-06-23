import 'dart:io';

import 'package:flutter/services.dart';
import 'package:weeksalive/core/app_icon/app_icon_id.dart';

class AppIconService {
  static const _channel = MethodChannel('com.weeksalive/app_icon');

  Future<bool> supportsAlternateIcons() async {
    if (!Platform.isIOS && !Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('supportsAlternateIcons') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> setIcon(AppIconId iconId) async {
    if (!Platform.isIOS && !Platform.isAndroid) return;
    if (!await supportsAlternateIcons()) return;

    final iconName = Platform.isIOS ? iconId.iosAlternateIconName : iconId.androidAlternateIconName;

    try {
      await _channel.invokeMethod<void>(
        'setAlternateIconName',
        {'iconName': iconName},
      );
    } on PlatformException {
      // Ignore transient platform errors; rely on persisted selection.
    }
  }
}
