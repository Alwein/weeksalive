import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';

abstract final class DefaultThemeTokens {
  static const light = AppColorTokens(
    content: Color(0xFF090909),
    contentMuted: Color(0xFFFFFFFF),
    contentSoft: Color(0xFF949494),
    contentExtraSoft: Color(0xFFCFCFCF),
    contentSoftOnSoft: Color(0xFF6E6E6E),
    bg: Color(0xFFFFFFFF),
    bgSoft: Color(0xFFF2F2F3),
    strokeColor: Color(0xFFEBEBEB),
    redWarning: Color(0xFFFF5C5C),
    greenSuccess: Color(0xFF43C59E),
    blueInfo: Color(0xFF007AFF),
    accentOrange: Color(0xFFFF8D28),
    accentMint: Color(0xFF00C8B3),
    accentPurple: Color(0xFFCB30E0),
  );

  static const dark = AppColorTokens(
    content: Color(0xFFFFFFFF),
    contentMuted: Color(0xFF090909),
    contentSoft: Color(0xFF8E8E8E),
    contentExtraSoft: Color(0xFF333232),
    contentSoftOnSoft: Color(0xFFA3A3A3),
    bg: Color(0xFF090909),
    bgSoft: Color(0xFF333333),
    strokeColor: Color(0xFF383838),
    redWarning: Color(0xFFFF5C5C),
    greenSuccess: Color(0xFF43C59E),
    blueInfo: Color(0xFF007AFF),
    accentOrange: Color(0xFFFF8D28),
    accentMint: Color(0xFF00C8B3),
    accentPurple: Color(0xFFCB30E0),
  );
}
