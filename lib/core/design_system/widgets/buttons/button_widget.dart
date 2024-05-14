import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/images/svg_asset_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/loading_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';

class UIButton extends StatelessWidget {
  const UIButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primary,
    this.width,
    this.isLoading = false,
    this.isDisabled = false,
    this.borderColor,
    this.leadingIconPath,
    this.elevation = 0,
    this.height = 56,
    this.trailingIconPath,
    this.fontSize = 16,
    this.horizontalPadding = 2,
    this.textColor = Colors.white,
  });

  final Color color;
  final Color textColor;
  final String text;
  final bool isLoading;
  final double fontSize;
  final double horizontalPadding;
  final String? leadingIconPath;
  final String? trailingIconPath;
  final bool isDisabled;
  final double? width;
  final double elevation;
  final double height;
  final Color? borderColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.7 : 1,
      child: IgnorePointer(
        ignoring: isLoading || isDisabled,
        child: UICoreButton(
          onPressed: onPressed,
          child: Container(
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 2,
                color: borderColor ?? color,
              ),
              color: color,
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: isLoading ? 0 : 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (leadingIconPath != null && !isDisabled) ...<Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: UISvgAsset(
                            path: leadingIconPath!,
                            size: 20,
                            color: textColor,
                          ),
                        ),
                      ],
                      Padding(
                        padding: EdgeInsets.only(
                          left: trailingIconPath != null ? 3 : 0,
                          right: leadingIconPath != null ? 3 : 0,
                        ),
                        child: UIText(
                          text,
                          maxLines: 1,
                          fontSize: fontSize,
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (trailingIconPath != null) ...<Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: UISvgAsset(
                            path: trailingIconPath!,
                            size: 20,
                            color: textColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isLoading) ...[
                  UILoadingIndicator(
                    size: height * 0.5,
                    verticalPadding: 0,
                    color: textColor,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}