import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ConfigurationRepository {
  Future<String> getTimeZone() async {
    return FlutterTimezone.getLocalTimezone();
  }

  Future<String> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String?> getCountryCode() {
    final countryCode = WidgetsBinding.instance.platformDispatcher.locale.countryCode;
    return Future.value(countryCode);
  }

  Future<String> getCurrencySymbol() {
    final format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return Future.value(format.currencySymbol);
  }

  Future<String> getLocale() {
    return Future.value(Platform.localeName);
  }

  Future<bool> getIsDarkMode() async {
    return Future.value(ThemeMode.system == ThemeMode.dark);
  }
}
