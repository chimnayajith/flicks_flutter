import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorsClass {
  static const Color primaryTheme = Color(0xFFA40DEE);
  static const Color secondaryTheme = Color(0xFF01DCD2);
  static const Color dotIndicatorUnselected = Color(0xFFD9D9D9);
  static const Color themeGreen = Color(0xFF798C00);
  static const Color themeYellow = Color(0xFFFFC700);
  static const Color answerPopUpGreen = Color(0xFF8FA500);
  static const Color answerPopUpRed = Color(0xFFB3261E);
  static const Color bg = Color(0xFFFEFBE3);

  static const Color lightgrey = Color(0xFF95938C);
  static const Color verylightgrey = Color(0xFFAFADA2);

  static const Color lightmodeNeutral500 = Color(0xFF605F60);
  static const Color lightmodeNeutral100 = Color(0xFFE4E1CD);

  static const Color red = Color(0xFFF5754C);
  static const LinearGradient homeGradient = LinearGradient(
    begin: Alignment(-0.00, -1.00),
    end: Alignment(0, 1),
    colors: [Color(0xFFA40DEE), Color(0xFFFEFBE3)],
  );
  static const LinearGradient themeBlueGradient = LinearGradient(
    begin: Alignment(-1.00, 0.09),
    end: Alignment(1, -0.09),
    colors: [Color(0xFFA40DEE), Color(0xFF01DCD2)],
  );

  // below to be deleted
  static const Color white = Color(0xFFFEFBE3);
  static const LinearGradient themeRedGradient = LinearGradient(
    begin: Alignment(1.00, 0.00),
    end: Alignment(-1, 0),
    colors: [Color(0xFFAE003E), Color(0xFF48001A)],
  );
  static const LinearGradient primaryThemeGradient = LinearGradient(
      begin: Alignment(-1.00, 0.09),
      end: Alignment(1, -0.09),
      colors: [Color(0xFFA40DEE), Color(0xFF01DCD2)]);

  static const Color offWhite = Color(0xFFFEFBE3);

  static const Color black = Color(0xFF000000);
  static const Color textGreen = Color(0xFF82C000);
  static const Color textGrey = Color(0xFF535353);
  static const Color lightTextGrey = Color(0xFF7A7976);
  static const Color textGrey1 = Color(0xFF605F60);
  static const Color textGrey2 = Color(0xFF95938C);
  static const Color boxShadow = Color(0x26000000);
  static const Color cartButtonColor = Color(0xFFC9C7B7);
}

class TextStylesClass {
  static TextStyle _style(
      double fontSize, double? fontHeight, FontWeight fontWeight,
      {Color color = ColorsClass.textGrey,
      FontStyle fontStyle = FontStyle.normal,
      TextDecoration decoration = TextDecoration.none}) {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
            fontSize: fontSize,
            height: fontHeight,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            color: color,
            decoration: decoration));
  }

  // Headings
  static TextStyle h1 = _style(48, 1.2, FontWeight.w600); // Semibold - 48/56
  static TextStyle h2 = _style(40, 1.15, FontWeight.w600); // Semibold - 40/46
  static TextStyle h3 = _style(36, 1.17, FontWeight.w600); // Semibold - 36/42
  static TextStyle h4 = _style(30, 1.33, FontWeight.w600); // Semibold - 30/40
  static TextStyle h5 = _style(24, 1.42, FontWeight.w600); // Semibold - 24/34
  static TextStyle h6 = _style(22, 1.54, FontWeight.w600); // Semibold - 22/34

  // Sub headings
  static TextStyle s1 = _style(20, 1.3, FontWeight.w600); // Semibold - 20/26
  static TextStyle s2 = _style(18, 1.33, FontWeight.w600); // Semibold - 18/24

  // Texts
  static TextStyle p1 = _style(16, 1.5, FontWeight.w500); // Medium - 16/24
  static TextStyle p2 = _style(14, 1.57, FontWeight.w500); // Medium - 14/24
  static TextStyle pb = _style(14, 1.57, FontWeight.w700); // Bold - 14/22
  static TextStyle quotes = _style(18, 1.22, FontWeight.w400,
      fontStyle: FontStyle.italic); // Regular - 18/22

  // Inputs
  static TextStyle label = _style(12, 1.83, FontWeight.w500); // Medium -12/22
  static TextStyle placeholder =
      _style(14, 1.57, FontWeight.w500); // Medium - 14/22
  static TextStyle assistive =
      _style(12, null, FontWeight.w500); // Medium - 12/Auto

  // Buttons/Links
  static TextStyle cta = _style(16, null, FontWeight.w500); // Medium - 16/Auto
  static TextStyle ctaLink = _style(18, null, FontWeight.w500,
      decoration: TextDecoration.underline); // Medium - 18/Auto
  static TextStyle ctaS = _style(14, null, FontWeight.w500); // Medium - 14/Auto
  static TextStyle ctaXS =
      _style(12, null, FontWeight.w500); // Medium - 12/Auto

  // Caption
  static TextStyle caption =
      _style(12, 1.33, FontWeight.w500); // Medium - 12/16

  // Overline
  static TextStyle overline1 =
      _style(22, 0.64, FontWeight.w500); // Medium - 22/14
  static TextStyle overline2 =
      _style(10, 1.4, FontWeight.w500); // Medium - 10/14

  static TextStyle customize(
    TextStyle baseStyle, {
    FontWeight? fontWeight,
    Color? color,
  }) {
    return baseStyle.copyWith(
      fontWeight: fontWeight,
      color: color,
    );
  }
}

ThemeData themedata = ThemeData(
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  primaryColor: ColorsClass.primaryTheme,
  scaffoldBackgroundColor: ColorsClass.bg,
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 24.sp,
      color: ColorsClass.lightmodeNeutral500,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 18.sp,
      color: ColorsClass.lightmodeNeutral500,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: 16.sp,
      color: ColorsClass.lightgrey,
      fontWeight: FontWeight.w400,
    ),
  ),
  cardColor: ColorsClass.white,
  buttonTheme: const ButtonThemeData(
    buttonColor: ColorsClass.primaryTheme,
    textTheme: ButtonTextTheme.primary,
  ),
  appBarTheme: const AppBarTheme(
    color: ColorsClass.primaryTheme,
  ),
);
