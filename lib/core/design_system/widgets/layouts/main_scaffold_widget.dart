import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/helpers/screen_size_widget_helper.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/back_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/buttons/button_widget.dart';
import 'package:tv_app/core/design_system/widgets/buttons/icon_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/bottom_app_bar.dart';
import 'package:tv_app/core/design_system/widgets/layouts/main_header_widget.dart';

class UIMainScaffold extends StatelessWidget {
  const UIMainScaffold({
    required this.body,
    this.backButton,
    this.hasSafeArea = true,
    this.webWrapperEnabled = true,
    this.canPop = true,
    this.backgroundColor,
    this.actionIconButton1,
    this.actionIconButton2,
    this.actionButton,
    this.mainHeader,
    this.bottomAppBar,
    super.key,
  });

  final Widget body;
  final UIBackButton? backButton;
  final bool hasSafeArea;
  final bool webWrapperEnabled;
  final bool canPop;
  final Color? backgroundColor;
  final UIIconButton? actionIconButton1;
  final UIIconButton? actionIconButton2;
  final UIButton? actionButton;
  final UIMainHeader? mainHeader;
  final UIBottomAppBar? bottomAppBar;

  @override
  Widget build(BuildContext context) {
    return Form(
      canPop: canPop,
      child: Scaffold(
        backgroundColor: backgroundColor ?? AppColors.background,
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                top: hasSafeArea,
                left: hasSafeArea,
                right: hasSafeArea,
                bottom: hasSafeArea,
                child: body,
              ),
            ),
            if (mainHeader != null) ...[
              Positioned(
                top: 0,
                child: mainHeader!,
              ),
            ],
            if (hasActionsButtons) ...[
              Positioned(
                top: 16,
                child: SafeArea(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        if (backButton != null) ...[
                          backButton!,
                        ],
                        const Spacer(),
                        if (actionIconButton1 != null) ...[
                          actionIconButton1!,
                        ],
                        if (actionIconButton2 != null) ...[
                          const SizedBox(width: 8),
                          actionIconButton2!,
                        ],
                        if (actionButton != null) ...[
                          const SizedBox(width: 8),
                          actionButton!,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
            if (bottomAppBar != null) ...[
              Positioned(
                bottom: 10,
                child: SafeArea(
                  child: Container(
                    width: ScreenSizeHelper.getScreenWidth(context: context),
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: bottomAppBar!,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool get hasActionsButtons =>
      (backButton != null ||
          actionIconButton1 != null ||
          actionButton != null ||
          actionIconButton2 != null) &&
      mainHeader == null;
}