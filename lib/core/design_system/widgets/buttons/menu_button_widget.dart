import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';

class UIMenuButton extends StatelessWidget {
  const UIMenuButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return UICoreButton(
      onPressed: onPressed,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 1.5,
            color: Colors.grey.shade300,
          ),
        ),
        padding: const EdgeInsets.all(13),
        child: Image.asset(
          '',
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}