import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';

class UICoreCard extends StatelessWidget {
  const UICoreCard({
    required this.child,
    this.borderColor = AppColors.border,
    this.onPressed,
    this.padding = 24,
    this.width,
    super.key,
  });

  final Widget child;
  final Color borderColor;
  final VoidCallback? onPressed;
  final double padding;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return UICoreButton(
      onPressed: onPressed != null ? onPressed! : () {},
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.dark2,
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: child,
          ),
        ),
      ),
    );
  }
}