import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UISvgAsset extends StatelessWidget {
  const UISvgAsset({
    required this.path,
    required this.color,
    required this.size,
    super.key,
  });

  final String path;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      height: size,
      width: size,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }
}