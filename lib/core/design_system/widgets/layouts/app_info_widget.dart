import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tv_app/core/dependencies/dependencies.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';

class UIAppInfo extends StatelessWidget {
  const UIAppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '© ${DateTime.now().year.toString()} Tv',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Version ${getIt<PackageInfo>().version}',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.white.withOpacity(.7),
          ),
        ),
      ],
    );
  }
}