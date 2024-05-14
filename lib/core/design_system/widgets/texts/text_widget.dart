import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/typography.dart';

class UIText extends StatelessWidget {
  const UIText(
    this.text, {
    this.color,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.shadows,
    this.textAlign,
    this.textWidthBasis,
    this.overflow,
    super.key,
  });

  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;
  final List<Shadow>? shadows;
  final TextAlign? textAlign;
  final TextWidthBasis? textWidthBasis;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      textWidthBasis: textWidthBasis,
      overflow: overflow,
      style: AppTypography.mainTextStyle.copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows: shadows,
      ),
    );
  }
}