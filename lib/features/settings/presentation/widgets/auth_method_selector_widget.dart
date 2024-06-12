import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';

class AuthMethodCardSelector extends StatelessWidget {
  const AuthMethodCardSelector({
    required this.title,
    required this.text,
    required this.isSelected,
    required this.onSelected,
    this.svgIconPath,
    this.svgIconUrl,
    this.content,
    super.key,
  });

  final String title;
  final String text;
  final bool isSelected;
  final VoidCallback onSelected;
  final String? svgIconPath;
  final String? svgIconUrl;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return UICoreButton(
      onPressed: onSelected,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.background,
          border: Border.all(
            color: isSelected ? AppColors.purple : AppColors.border,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: UIText(
                    title,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  color: AppColors.purple,
                  size: 26,
                ),
              ],
            ),
            const SizedBox(height: 8),
            UIText(
              text,
            ),
            if (content != null) ...[
              content!,
            ],
          ],
        ),
      ),
    );
  }
}