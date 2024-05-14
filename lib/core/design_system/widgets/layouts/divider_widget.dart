import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';

class UIDivider extends StatelessWidget {
  const UIDivider({
    this.height = 1,
    this.thickness = 1,
    this.color,
    super.key,
  });

  final double height;
  final double thickness;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? AppColors.border,
      thickness: thickness,
      height: height,
    );
  }
}