import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:weeksalive/initialization.dart';
import 'package:weeksalive/presentation/app/app.dart';

void main() async {
  await initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales,
      fallbackLocale: const Locale('en', 'US'),
      path: 'assets/translations',
      child: const App(),
    ),
  );
}

const supportedLocales = [
  Locale('en', 'US'), // English : en_US.json
  // Locale('de', 'DE'), // German : de_DE.json
  // Locale('ar', 'SA'), // Arabic : ar_SA.json
  // Locale('zh', 'CN'), // Chinese (Simplified) : zh_CN.json
  // Locale('zh', 'TW'), // Chinese (Traditional) : zh_TW.json
  // Locale('ko', 'KR'), // Korean : ko_KR.json
  // Locale('da', 'DK'), // Danish : da_DK.json
  // Locale('es', 'ES'), // Spanish : es_ES.json
  // Locale('fi', 'FI'), // Finnish : fi_FI.json
  // Locale('fr', 'FR'), // French : fr_FR.json
  // Locale('el', 'GR'), // Greek : el_GR.json
  // Locale('he', 'IL'), // Hebrew : he_IL.json
  // Locale('hi', 'IN'), // Hindi : hi_IN.json
  // Locale('id', 'ID'), // Indonesian (Bahasa) : id_ID.json
  // Locale('it', 'IT'), // Italian : it_IT.json
  // Locale('ja', 'JP'), // Japanese : ja_JP.json
  // Locale('nl', 'NL'), // Dutch : nl_NL.json
  // Locale('no', 'NO'), // Norwegian : no_NO.json
  // Locale('pl', 'PL'), // Polish : pl_PL.json
  // Locale('pt', 'BR'), // Portuguese : pt_BR.json
  // Locale('ro', 'RO'), // Romanian : ro_RO.json
  // Locale('ru', 'RU'), // Russian : ru_RU.json
  // Locale('sv', 'SE'), // Swedish : sv_SE.json
  // Locale('cs', 'CZ'), // Czech : cs_CZ.json
  // Locale('th', 'TH'), // Thai : th_TH.json
  // Locale('tr', 'TR'), // Turkish : tr_TR.json
  // Locale('uk', 'UA'), // Ukrainian : uk_UA.json
  // Locale('vi', 'VN'), // Vietnamese : vi_VN.json
];
