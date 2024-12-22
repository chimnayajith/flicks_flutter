import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtils {
  static double screenHeight(BuildContext context) {
    return 1.sh;
  }

  static double screenWidth(BuildContext context) {
    return 1.sw;
  }

  static double blockSizeHorizontal(BuildContext context, double percentage) {
    return 1.sw * percentage / 100;
  }

  static double blockSizeVertical(BuildContext context, double percentage) {
    return 1.sh * percentage / 100;
  }

  static double h1(BuildContext context) {
    return 0.009.sh;
  }

  static double h2(BuildContext context) {
    return 0.018.sh;
  }

  static double h3(BuildContext context) {
    return 0.036.sh;
  }

  static double h4(BuildContext context) {
    return 0.073.sh;
  }

  static double h5(BuildContext context) {
    return 0.146.sh;
  }

  static double h6(BuildContext context) {
    return 0.109.sh;
  }

  static double h7(BuildContext context) {
    return 0.027.sh;
  }

  static double w1(BuildContext context) {
    return 0.021.sw;
  }

  static double w2(BuildContext context) {
    return 0.043.sw;
  }

  static double w3(BuildContext context) {
    return 0.085.sw;
  }

  static double w4(BuildContext context) {
    return 0.171.sw;
  }

  static double w5(BuildContext context) {
    return 0.341.sw;
  }

  static double w6(BuildContext context) {
    return 0.256.sw;
  }
  
  static double w7(BuildContext  context) {
    return 0.064.sw;
  }
}
