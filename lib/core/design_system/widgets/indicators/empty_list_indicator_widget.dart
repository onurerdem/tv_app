import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';

class UIEmptyListIndicator extends StatelessWidget {
  const UIEmptyListIndicator({
    this.text,
    this.iconColor = AppColors.primary,
    super.key,
  });

  final String? text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            padding: const EdgeInsets.all(20),
            child: Icon(
              Icons.search_off_rounded,
              color: iconColor,
              size: 90,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: 220,
            alignment: Alignment.center,
            child: UIText(
              text ?? 'No items found.',
              textAlign: TextAlign.center,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}