import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/images/svg_asset_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/loading_indicator_widget.dart';

class UIIconButton extends StatelessWidget {
  const UIIconButton({
    required this.backgroundColor,
    required this.onPressed,
    required this.svgIconPath,
    this.isLoading = false,
    this.isDisabled = false,
    this.iconSize = 24,
    this.iconColor = AppColors.white,
    super.key,
  });

  final VoidCallback onPressed;
  final Color backgroundColor;
  final double iconSize;
  final String svgIconPath;
  final bool isLoading;
  final bool isDisabled;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return UICoreButton(
      onPressed: onPressed,
      isDisabled: isDisabled,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
        ),
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        child: Builder(builder: (BuildContext context) {
          if (isLoading) {
            return UILoadingIndicator(
              size: 20,
              color: iconColor,
            );
          }
          return UISvgAsset(
            path: svgIconPath,
            color: iconColor,
            size: iconSize,
          );
        }),
      ),
    );
  }
}