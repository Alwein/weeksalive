import 'package:flutter/material.dart';

@immutable
class AppColorTokens {
  const AppColorTokens({
    required this.content,
    required this.contentMuted,
    required this.contentSoft,
    required this.contentExtraSoft,
    required this.contentSoftOnSoft,
    required this.bg,
    required this.bgSoft,
    required this.strokeColor,
    required this.redWarning,
    required this.greenSuccess,
    required this.blueInfo,
    required this.accentOrange,
    required this.accentMint,
    required this.accentPurple,
  });

  final Color content;
  final Color contentMuted;
  final Color contentSoft;
  final Color contentExtraSoft;
  final Color contentSoftOnSoft;
  final Color bg;
  final Color bgSoft;
  final Color strokeColor;
  final Color redWarning;
  final Color greenSuccess;
  final Color blueInfo;
  final Color accentOrange;
  final Color accentMint;
  final Color accentPurple;

  AppColorTokens lerp(AppColorTokens other, double t) {
    return AppColorTokens(
      content: Color.lerp(content, other.content, t)!,
      contentMuted: Color.lerp(contentMuted, other.contentMuted, t)!,
      contentSoft: Color.lerp(contentSoft, other.contentSoft, t)!,
      contentExtraSoft: Color.lerp(contentExtraSoft, other.contentExtraSoft, t)!,
      contentSoftOnSoft: Color.lerp(contentSoftOnSoft, other.contentSoftOnSoft, t)!,
      bg: Color.lerp(bg, other.bg, t)!,
      bgSoft: Color.lerp(bgSoft, other.bgSoft, t)!,
      strokeColor: Color.lerp(strokeColor, other.strokeColor, t)!,
      redWarning: Color.lerp(redWarning, other.redWarning, t)!,
      greenSuccess: Color.lerp(greenSuccess, other.greenSuccess, t)!,
      blueInfo: Color.lerp(blueInfo, other.blueInfo, t)!,
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t)!,
      accentMint: Color.lerp(accentMint, other.accentMint, t)!,
      accentPurple: Color.lerp(accentPurple, other.accentPurple, t)!,
    );
  }
}
