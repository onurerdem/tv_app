import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:tv_app/core/dependencies/dependencies.dart';
import 'package:tv_app/core/design_system/helpers/asset_svgs_helper.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/buttons/icon_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';
import 'package:tv_app/core/navigation/services/navigation_service.dart';

class UIMainHeader extends StatelessWidget {
  const UIMainHeader({
    this.height = 120,
    this.child,
    this.isProtected = true,
    super.key,
  });

  final Widget? child;
  final double height;
  final bool isProtected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Transform.translate(
        offset: const Offset(0, -2),
        child: Transform.scale(
          scale: 1.02,
          child: GlassContainer(
            height: height,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(26),
              bottomRight: Radius.circular(26),
            ),
            color: AppColors.background.withOpacity(.84),
            borderColor: AppColors.background,
            blur: 7,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  width: 1.5,
                  color: AppColors.border,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(26),
                  bottomRight: Radius.circular(26),
                ),
              ),
              child: Column(
                children: [
                  if (isProtected) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          UICoreButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    color: AppColors.dark1,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '🍿',
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const UIText(
                                  'Profile',
                                  maxLines: 1,
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          UIIconButton(
                            backgroundColor: Colors.transparent,
                            onPressed: getIt<AppNavigationService>()
                                .routeToFavoriteTvShows,
                            svgIconPath: AssetSvgsHelper.bookmark,
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (child != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: child!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}