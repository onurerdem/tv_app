import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/theme/typography.dart';

class UIHeaderText extends StatelessWidget {
  const UIHeaderText(
    this.text, {
    this.fontSize = 32,
    this.maxLines = 1,
    super.key,
  });

  final String text;
  final double fontSize;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      maxLines: maxLines,
      style: AppTypography.mainTextStyle.copyWith(
        color: AppColors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}