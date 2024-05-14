import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';

class UILoadingIndicator extends StatelessWidget {
  const UILoadingIndicator({
    this.size = 60,
    this.verticalPadding = 0,
    this.strokeWidth = 2,
    this.color,
    super.key,
  });

  final double size;
  final double verticalPadding;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
      ),
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            color: color ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}