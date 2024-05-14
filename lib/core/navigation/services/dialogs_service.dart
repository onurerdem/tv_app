import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/dialogs/confirmation_dialog_widget.dart';
import 'package:tv_app/core/design_system/widgets/dialogs/core_dialog_widget.dart';

class AppDialogsService {
  AppDialogsService({
    required this.appRouter,
  }) {
    context = appRouter.routerDelegate.navigatorKey.currentContext!;
  }
  final GoRouter appRouter;

  late BuildContext context;

  void showConfirmationDialog({
    required String title,
    required String text,
    required VoidCallback onConfirmation,
    Color primaryColor = AppColors.primary,
    Color buttonTextColor = AppColors.white,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return UIConfirmationDialog(
          key: UniqueKey(),
          title: title,
          text: text,
          onConfirmation: onConfirmation,
          primaryColor: primaryColor,
          buttonTextColor: buttonTextColor,
        );
      },
    );
  }

  Future<void> showSuccessDialog({
    required String text,
    Widget? icon,
    String? title,
    String? buttonText,
    Color primaryColor = AppColors.green,
  }) =>
      showDialog(
        context: context,
        builder: (_) => UICoreDialog(
          key: UniqueKey(),
          title: title ?? 'Success',
          text: text,
          buttonText: buttonText,
          icon: icon,
          primaryColor: primaryColor,
        ),
      );

  Future<void> showInfoDialog({
    required String text,
    String? title,
    String? buttonText,
    Function()? onPressed,
    Key? key,
  }) async {
    await showDialog(
      context: context,
      builder: (_) {
        return UICoreDialog(
          key: key,
          title: title ?? 'Success',
          text: text,
          buttonText: buttonText,
          onPressed: onPressed,
        );
      },
    );
  }

  void showErrorDialog({
    required String text,
    String? title,
    String? buttonText,
    Function()? onPressed,
    Key? key,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return UICoreDialog(
          key: key,
          title: title ?? 'Error',
          text: text,
          buttonText: buttonText,
          buttonTextColor: AppColors.white,
          isError: true,
          onPressed: onPressed,
        );
      },
    );
  }
}