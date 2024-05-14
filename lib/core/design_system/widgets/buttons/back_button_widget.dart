import 'package:glass_kit/glass_kit.dart';
import 'package:tv_app/core/design_system/helpers/asset_svgs_helper.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/images/svg_asset_widget.dart';
import 'package:flutter/material.dart';

class UIBackButton extends StatelessWidget {
  const UIBackButton({
    required this.color,
    this.onPressed,
    this.triggerReload,
    super.key,
  });

  final VoidCallback? onPressed;
  final Color color;
  final VoidCallback? triggerReload;

  @override
  Widget build(BuildContext context) {
    return UICoreButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: GlassContainer(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.background.withOpacity(.5),
        borderColor: color,
        blur: 3,
        height: 40,
        width: 40,
        borderWidth: 2,
        child: Center(
          child: UISvgAsset(
            path: AssetSvgsHelper.arrowBack,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }
}