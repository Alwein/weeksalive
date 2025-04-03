import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateUserConfigRequest {
  final String? appVersion;
  final String? currencySymbol;
  final String? locale;
  final String? timeZone;

  UpdateUserConfigRequest({
    required this.appVersion,
    required this.currencySymbol,
    required this.locale,
    required this.timeZone,
  });

  factory UpdateUserConfigRequest.create({
    required String appVersion,
    required String currencySymbol,
    required String locale,
    required String timeZone,
  }) {
    return UpdateUserConfigRequest(
      appVersion: appVersion,
      currencySymbol: currencySymbol,
      locale: locale,
      timeZone: timeZone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appVersion': appVersion,
      'currencySymbol': currencySymbol,
      'locale': locale,
      'lastConnectionDate': FieldValue.serverTimestamp(),
      'timeZone': timeZone,
    };
  }
}
