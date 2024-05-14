import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/theme/typography.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/loading_indicator_widget.dart';

class UITextButton extends StatelessWidget {
  const UITextButton({
    required this.onPressed,
    required this.text1,
    this.text2,
    this.isLoading = false,
    super.key,
  });

  final String text1;
  final String? text2;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return UICoreButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: IntrinsicWidth(
          child: Row(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: text1),
                    if (text2 != null) ...[
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: '$text2',
                        style: const TextStyle(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ],
                ),
                style: AppTypography.mainTextStyle.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isLoading) ...[
                const SizedBox(width: 8),
                const UILoadingIndicator(
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}