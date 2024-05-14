import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ScreenSizeHelper {
  ScreenSizeHelper._();

  static double getScreenWidth({
    required BuildContext context,
  }) {
    if (isWebLayout(
      context: context,
    )) {
      return 500;
    }
    return MediaQuery.of(context).size.width;
  }

  static bool isWebLayout({
    required BuildContext context,
  }) =>
      kIsWeb && MediaQuery.of(context).size.width > 500;
}