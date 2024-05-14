import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/button_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';

class UIConfirmationDialog extends StatelessWidget {
  const UIConfirmationDialog({
    required this.title,
    required this.text,
    required this.onConfirmation,
    this.primaryColor = AppColors.primary,
    this.buttonTextColor = AppColors.white,
    super.key,
  });

  final String title;
  final String text;
  final VoidCallback onConfirmation;
  final Color primaryColor;
  final Color buttonTextColor;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width > 600
        ? 400
        : MediaQuery.of(context).size.width * 0.85;
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(0),
      insetPadding: const EdgeInsets.all(0),
      content: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.background,
          border: Border.all(
            width: 1.5,
            color: AppColors.border,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 24),
              UIText(
                title.toUpperCase(),
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  color: AppColors.border,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: UIText(
                  text,
                  color: AppColors.white,
                  fontSize: 20,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: UIButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: 'Cancel',
                        textColor: primaryColor,
                        height: 50,
                        color: AppColors.background,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: UIButton(
                        onPressed: () {
                          onConfirmation();
                          Navigator.of(context).pop();
                        },
                        color: primaryColor,
                        textColor: buttonTextColor,
                        text: 'Yes',
                        height: 50,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}