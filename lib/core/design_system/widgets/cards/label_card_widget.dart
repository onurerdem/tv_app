import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/images/svg_asset_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';

class UILabelCard extends StatelessWidget {
  const UILabelCard({
    required this.text,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.fontSize = 12,
    this.borderColor,
    this.horizontalPadding = 14,
    this.verticalPadding = 8,
    this.iconSize = 16,
    this.onPressed,
    this.svgIconPath,
    super.key,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double fontSize;
  final double verticalPadding;
  final double horizontalPadding;
  final VoidCallback? onPressed;
  final String? svgIconPath;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return UICoreButton(
      onPressed: onPressed != null ? onPressed! : () {},
      child: IntrinsicWidth(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: backgroundColor,
            border: Border.all(
              width: 1.5,
              color: borderColor ?? backgroundColor,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Row(
            children: [
              if (svgIconPath != null) ...[
                UISvgAsset(
                  path: svgIconPath!,
                  color: textColor,
                  size: iconSize,
                ),
                const SizedBox(width: 8),
              ],
              UIText(
                text,
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
                color: textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}