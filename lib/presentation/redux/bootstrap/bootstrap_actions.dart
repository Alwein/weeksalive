class BootstrapAction {}

/// The app came back to the foreground: the device may have moved to another
/// time zone while it was in the background.
class RefreshTimeZoneAction {
  const RefreshTimeZoneAction();
}

/// The device is in another time zone than when the days were loaded: their
/// local midnights and the notifications are recomputed in the new one.
class TimeZoneChangedAction {
  const TimeZoneChangedAction();
}
