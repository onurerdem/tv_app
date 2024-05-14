import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class PageBuilderService {
  static Page<T> pageBuilder<T>({
    required Widget child,
  }) {
    if (kIsWeb || Platform.isAndroid) {
      return NoTransitionPage<T>(child: child);
    }
    return CupertinoPage<T>(
      child: child,
    );
  }
}