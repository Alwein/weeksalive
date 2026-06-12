import 'package:flutter/material.dart';
import 'package:weeksalive/core/styles/app_color_tokens.dart';

/// Chromatic theme token sets — one fixed appearance per theme.
abstract final class ChromaticThemeTokens {
  /// Rose - Pétale (clair): fond nacré, accent rose, texte bordeaux.
  static const petale = AppColorTokens(
    content: Color(0xFF8C2D52),
    contentMuted: Color(0xFFFFF5F7),
    contentSoft: Color(0xFFB5688A),
    contentExtraSoft: Color(0xFFF4C4D4),
    contentSoftOnSoft: Color(0xFF9A4A68),
    bg: Color(0xFFFFF8FA),
    bgSoft: Color(0xFFFFEAF0),
    strokeColor: Color(0xFFF4C8D8),
    redWarning: Color(0xFFD63F5E),
    greenSuccess: Color(0xFF5A9E7A),
    blueInfo: Color(0xFF7888C8),
    accentOrange: Color(0xFFE0826A),
    accentMint: Color(0xFF68B090),
    accentPurple: Color(0xFFF4A3BC),
  );

  /// Rose profond, fond mûre.
  static const pivoine = AppColorTokens(
    content: Color(0xFFF5D4DC),
    contentMuted: Color(0xFF1E1018),
    contentSoft: Color(0xFFB08090),
    contentExtraSoft: Color(0xFF4A2838),
    contentSoftOnSoft: Color(0xFFD0A0B0),
    bg: Color(0xFF1E1018),
    bgSoft: Color(0xFF3A2030),
    strokeColor: Color(0xFF4A3040),
    redWarning: Color(0xFFFF6A7A),
    greenSuccess: Color(0xFF5CB88A),
    blueInfo: Color(0xFF8A9FD4),
    accentOrange: Color(0xFFE87888),
    accentMint: Color(0xFF6AB89A),
    accentPurple: Color(0xFFD878C8),
  );

  /// Marron café, fond crème.
  static const cafe = AppColorTokens(
    content: Color(0xFF3D2B1F),
    contentMuted: Color(0xFFFAF6F0),
    contentSoft: Color(0xFF8A7568),
    contentExtraSoft: Color(0xFFD4C8BC),
    contentSoftOnSoft: Color(0xFF6A5548),
    bg: Color(0xFFFAF6F0),
    bgSoft: Color(0xFFEDE4D8),
    strokeColor: Color(0xFFE0D4C8),
    redWarning: Color(0xFFD85A4A),
    greenSuccess: Color(0xFF5A9A6A),
    blueInfo: Color(0xFF6A8AB0),
    accentOrange: Color(0xFFC87840),
    accentMint: Color(0xFF6A9A7A),
    accentPurple: Color(0xFF9A6A8A),
  );

  /// Vert sauge, fond forêt.
  static const matcha = AppColorTokens(
    content: Color(0xFFD4E4C8),
    contentMuted: Color(0xFF1A2820),
    contentSoft: Color(0xFF8AA888),
    contentExtraSoft: Color(0xFF3A4A38),
    contentSoftOnSoft: Color(0xFFA8C0A0),
    bg: Color(0xFF1A2820),
    bgSoft: Color(0xFF2E4034),
    strokeColor: Color(0xFF3E5044),
    redWarning: Color(0xFFE87868),
    greenSuccess: Color(0xFF6AB878),
    blueInfo: Color(0xFF78A8C0),
    accentOrange: Color(0xFFD0A060),
    accentMint: Color(0xFF88C0A0),
    accentPurple: Color(0xFFA888C0),
  );

  /// Violet poudré, fond crème.
  static const lavande = AppColorTokens(
    content: Color(0xFF2E2248),
    contentMuted: Color(0xFFF8F5FC),
    contentSoft: Color(0xFF7A68A8),
    contentExtraSoft: Color(0xFFD4C8E4),
    contentSoftOnSoft: Color(0xFF6A5A7A),
    bg: Color(0xFFF8F5FC),
    bgSoft: Color(0xFFE2DAF0),
    strokeColor: Color(0xFFDCD4E8),
    redWarning: Color(0xFFE06A7A),
    greenSuccess: Color(0xFF5AAA8A),
    blueInfo: Color(0xFF6A88D0),
    accentOrange: Color(0xFFD4846A),
    accentMint: Color(0xFF68A8B8),
    accentPurple: Color(0xFFA87ED4),
  );

  /// Ardoise sombre — bleu-gris froid, accent acier.
  static const ardoise = AppColorTokens(
    content: Color(0xFFCDD8E8),
    contentMuted: Color(0xFF0E141C),
    contentSoft: Color(0xFF7A90A8),
    contentExtraSoft: Color(0xFF2A3848),
    contentSoftOnSoft: Color(0xFF9EB0C4),
    bg: Color(0xFF0E141C),
    bgSoft: Color(0xFF1C2A38),
    strokeColor: Color(0xFF243040),
    redWarning: Color(0xFFE06870),
    greenSuccess: Color(0xFF5AB890),
    blueInfo: Color(0xFF5A98D0),
    accentOrange: Color(0xFFD09060),
    accentMint: Color(0xFF60B0C8),
    accentPurple: Color(0xFF8890D0),
  );

  /// Terracotta sombre — adobe/désert chaud.
  static const terracotta = AppColorTokens(
    content: Color(0xFFEDD9C0),
    contentMuted: Color(0xFF1C1008),
    contentSoft: Color(0xFFA87858),
    contentExtraSoft: Color(0xFF4A2E1C),
    contentSoftOnSoft: Color(0xFFC89870),
    bg: Color(0xFF1C1008),
    bgSoft: Color(0xFF3A2010),
    strokeColor: Color(0xFF4A2E18),
    redWarning: Color(0xFFE87858),
    greenSuccess: Color(0xFF7AB880),
    blueInfo: Color(0xFF78A8B8),
    accentOrange: Color(0xFFE8904A),
    accentMint: Color(0xFF6AB8A0),
    accentPurple: Color(0xFFC09878),
  );
}
