import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static TextStyle appTitle = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.xl,
    fontWeight: FontWeight.w600,
  );

  static TextStyle primaryXxlBold = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.xxxl,
    fontWeight: FontWeight.normal,
    height: 0,
  );

  static TextStyle primaryXxlBoldResponsive(double screenwidth) {
    double fontSize = FontSizes.xxxl;
    if (screenwidth < 400) {
      fontSize = FontSizes.xxl;
    }

    return GoogleFonts.splineSans().copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      height: 0,
    );
  }

  static TextStyle primaryRegular = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.normal,
    fontWeight: FontWeight.normal,
  );

  static TextStyle primaryMedium = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle primaryBold = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.normal,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryMediumBlack = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryMediumNormal = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.normal,
  );

  static TextStyle primaryHugeBold = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.huge,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryHuge = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.huge,
    fontWeight: FontWeight.normal,
  );

  static TextStyle primaryXlBold = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.xl,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryLargeMedium = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.large,
    fontWeight: FontWeight.w600,
    height: 0,
  );

  static TextStyle primaryLarge = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.large,
    fontWeight: FontWeight.normal,
    height: 0,
  );

  static TextStyle primaryXsRegular = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.xs,
    fontWeight: FontWeight.normal,
  );
  static TextStyle primaryXsMedium = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.xs,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mediumBold = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w800,
  );

  static TextStyle primaryMediumMedium = GoogleFonts.splineSans().copyWith(
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w800,
  );
}

class FontSizes {
  static const double xxxl = 64;
  static const double xxl = 48;
  static const double xl = 32;
  static const double huge = 24;
  static const double semi = 20;
  static const double large = 18;
  static const double medium = 16;
  static const double normal = 14;
  static const double xs = 12;
  static const double small = 11;
  static const double extraSmall = 10;
}
