import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/helpers/asset_svgs_helper.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/images/svg_asset_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';

class UIArrowButton extends StatelessWidget {
  const UIArrowButton({
    required this.onPressed,
    required this.iconColor,
    required this.svgIconPath,
    required this.title,
    super.key,
  });

  final VoidCallback onPressed;
  final Color iconColor;
  final String svgIconPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return UICoreButton(
      onPressed: onPressed,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UISvgAsset(
                  path: svgIconPath,
                  color: iconColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: UIText(
                    title,
                  ),
                ),
                UISvgAsset(
                  path: AssetSvgsHelper.arrowAltRight,
                  color: Colors.grey.shade400,
                  size: 24,
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColors.border,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}