import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/button_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';

class UICoreDialog extends StatelessWidget {
  const UICoreDialog({
    required this.title,
    this.text = '',
    this.circleColor,
    this.buttonText,
    this.isError = false,
    this.onPressed,
    this.icon,
    this.primaryColor = AppColors.green,
    this.buttonTextColor = AppColors.background,
    super.key,
  });

  final String title;
  final String text;
  final bool isError;
  final String? buttonText;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? circleColor;
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
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 30,
                backgroundColor: isError
                    ? AppColors.red.withOpacity(.1)
                    : circleColor ?? AppColors.green.withOpacity(.2),
                child: isError
                    ? const Icon(
                        Icons.close,
                        color: AppColors.red,
                        size: 30,
                      )
                    : icon ??
                        Icon(
                          Icons.check,
                          color: primaryColor,
                          size: 30,
                        ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (text.isNotEmpty) ...<Widget>[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: UIText(
                    text,
                    color: AppColors.text,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: UIButton(
                  text: buttonText ?? 'OK',
                  color: isError ? AppColors.red : primaryColor,
                  textColor: isError ? AppColors.white : buttonTextColor,
                  height: 45,
                  onPressed: () {
                    if (onPressed != null) {
                      onPressed!();
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}