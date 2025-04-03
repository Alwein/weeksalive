class AppVersionUtils {
  static bool shouldForceUpdate(String? currentVersion, String? minVersion) {
    if (currentVersion == null || minVersion == null) {
      return false;
    }

    final currentVersionParts = currentVersion.split('.');
    final minVersionParts = minVersion.split('.');

    for (var i = 0; i < minVersionParts.length; i++) {
      final currentVersionPart = int.parse(currentVersionParts[i]);
      final minVersionPart = int.parse(minVersionParts[i]);

      if (currentVersionPart > minVersionPart) {
        return false;
      } else if (currentVersionPart < minVersionPart) {
        return true;
      }
    }

    return false;
  }
}
