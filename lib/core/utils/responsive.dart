import 'package:flutter/material.dart';

abstract final class ResponsiveUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= 600 && width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 1024;
  }

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return 20;
    }

    if (width < 1024) {
      return 32;
    }

    return 48;
  }

  static int categoryGridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return 2;
    }

    if (width < 900) {
      return 3;
    }

    return 4;
  }
}