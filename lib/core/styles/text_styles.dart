import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle primaryLargeBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.large,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primarySemiBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.semi,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryRegularBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.regular,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryMediumBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.bold,
  );

  static TextStyle xlBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.xl,
    fontWeight: FontWeight.bold,
  );

  static TextStyle hugeBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.huge,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryXxlBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.xxxl,
    fontWeight: FontWeight.normal,
    height: 0,
  );

  static TextStyle primaryXxlBoldResponsive(double screenwidth) {
    double fontSize = FontSizes.xxxl;
    if (screenwidth < 400) {
      fontSize = FontSizes.xxl;
    }

    return TextStyle(
      fontFamily: "SpaceGrotesk",
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      height: 0,
    );
  }

  static TextStyle primaryRegular = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.regular,
    fontWeight: FontWeight.normal,
  );

  static TextStyle primaryMediumMedium = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w500,
    height: 1.6,
  );

  static TextStyle primaryBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.regular,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryMediumBlack = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryMediumNormal = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.normal,
  );

  static TextStyle primaryHugeBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.huge,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryHuge = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.huge,
    fontWeight: FontWeight.normal,
  );

  static TextStyle primaryXlBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.xl,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryLargeMedium = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.large,
    fontWeight: FontWeight.w500,
    height: 0,
  );

  static TextStyle primaryLarge = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.large,
    fontWeight: FontWeight.normal,
    height: 0,
  );

  static TextStyle primarySmallRegular = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.small,
    fontWeight: FontWeight.normal,
  );
  static TextStyle primarySmallMedium = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.small,
    fontWeight: FontWeight.w500,
  );

  static TextStyle primarySmallBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.small,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primaryXsBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.extraSmall,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumBold = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.medium,
    fontWeight: FontWeight.w800,
  );

  static TextStyle primaryRegularMedium = const TextStyle(
    fontFamily: "SpaceGrotesk",
    fontSize: FontSizes.regular,
    fontWeight: FontWeight.w500,
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
  static const double regular = 14;
  static const double small = 12;
  static const double extraSmall = 10;
}
