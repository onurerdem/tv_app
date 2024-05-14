import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData theme = ThemeData(
    primarySwatch: AppColors.primarySwatch,
    scaffoldBackgroundColor: AppColors.background,
  );
}