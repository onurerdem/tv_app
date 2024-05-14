import 'package:flutter/widgets.dart';

class UICoreButton extends StatelessWidget {
  const UICoreButton({
    required this.onPressed,
    required this.child,
    this.requestFocus = true,
    this.isDisabled = false,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget child;
  final bool requestFocus;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isDisabled,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (requestFocus) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
            onPressed();
          },
          child: child,
        ),
      ),
    );
  }
}