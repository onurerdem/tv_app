import 'package:flutter/material.dart';

class UIProgressBar extends StatelessWidget {
  const UIProgressBar({
    required this.progressValue,
    required this.backgroundColor,
    required this.progressBarColor,
    super.key,
  });

  final double progressValue;
  final Color progressBarColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          24,
        ),
        color: backgroundColor,
      ),
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progressValue,
        child: Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              24,
            ),
            color: progressBarColor,
          ),
        ),
      ),
    );
  }
}