import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weeksalive/initialization.dart';
import 'package:weeksalive/presentation/app/app.dart';

void main() async {
  final dependencies = await initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales,
      fallbackLocale: const Locale('en', 'US'),
      path: 'assets/translations',
      child: App(
        store: dependencies.store,
        pushNotificationRepository: dependencies.pushNotificationRepository,
      ),
    ),
  );
}

const supportedLocales = [
  Locale('en', 'US'), // English : en-US.json
  Locale('de', 'DE'), // German : de-DE.json
  Locale('zh', 'CN'), // Chinese (Simplified) : zh-CN.json
  Locale('ko', 'KR'), // Korean : ko-KR.json
  Locale('da', 'DK'), // Danish : da-DK.json
  Locale('es', 'ES'), // Spanish : es-ES.json
  Locale('fi', 'FI'), // Finnish : fi-FI.json
  Locale('fr', 'FR'), // French : fr-FR.json
  Locale('el', 'GR'), // Greek : el-GR.json
  Locale('id', 'ID'), // Indonesian (Bahasa) : id-ID.json
  Locale('it', 'IT'), // Italian : it-IT.json
  Locale('ja', 'JP'), // Japanese : ja-JP.json
  Locale('nl', 'NL'), // Dutch : nl-NL.json
  Locale('no', 'NO'), // Norwegian : no-NO.json
  Locale('pl', 'PL'), // Polish : pl-PL.json
  Locale('pt', 'BR'), // Portuguese : pt-BR.json
  Locale('ro', 'RO'), // Romanian : ro-RO.json
  Locale('ru', 'RU'), // Russian : ru-RU.json
  Locale('sv', 'SE'), // Swedish : sv-SE.json
  Locale('cs', 'CZ'), // Czech : cs-CZ.json
  Locale('th', 'TH'), // Thai : th-TH.json
  Locale('tr', 'TR'), // Turkish : tr-TR.json
  Locale('uk', 'UA'), // Ukrainian : uk-UA.json
  Locale('vi', 'VN'), // Vietnamese : vi-VN.json
];
