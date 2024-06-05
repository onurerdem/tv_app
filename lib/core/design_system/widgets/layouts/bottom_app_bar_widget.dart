import 'package:glass_kit/glass_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:tv_app/core/dependencies/dependencies.dart';
import 'package:tv_app/core/design_system/helpers/asset_svgs_helper.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/images/svg_asset_widget.dart';
import 'package:tv_app/core/navigation/services/navigation_service.dart';

enum TabType {
  tvShows,
  actors,
  settings,
}

class UIBottomAppBar extends StatelessWidget {
  const UIBottomAppBar({
    required this.currentTab,
    super.key,
  });

  final TabType currentTab;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
        builder: (BuildContext context, bool visible) {
      if (visible) {
        return const SizedBox();
      }
      return SafeArea(
        top: false,
        bottom: true,
        child: GlassContainer(
          height: double.infinity,
          width: double.infinity,
          borderRadius: BorderRadius.circular(64),
          color: AppColors.black.withOpacity(.8),
          borderColor: AppColors.black.withOpacity(.8),
          blur: 7,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconButton(
                  tabType: TabType.tvShows,
                ),
                _buildIconButton(
                  tabType: TabType.actors,
                ),
                _buildIconButton(
                  tabType: TabType.settings,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildIconButton({
    required TabType tabType,
  }) =>
      UICoreButton(
        onPressed: () => _navigate(
          tabType: tabType,
        ),
        child: Container(
          height: 40,
          padding:
              EdgeInsets.symmetric(horizontal: tabType == currentTab ? 16 : 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: tabType == currentTab
                  ? _getBackgroundColor(tabType: tabType)
                  : Colors.transparent),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UISvgAsset(
                path: _getIconPath(
                    tabType: tabType, isSelected: tabType == currentTab),
                color: _getTextColor(
                  tabType: tabType,
                  currentTapType: currentTab,
                ),
                size: 20,
              ),
              if (currentTab == tabType) ...[
                const SizedBox(
                  width: 8,
                ),
                Text(
                  _getText(
                    tabType: tabType,
                  ),
                  maxLines: 1,
                  style: TextStyle(
                    color: _getTextColor(
                      tabType: tabType,
                      currentTapType: currentTab,
                    ),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      );

  String _getText({
    required TabType tabType,
  }) {
    switch (tabType) {
      case TabType.tvShows:
        return 'Tv Shows';
      case TabType.actors:
        return 'Actors';
      case TabType.settings:
        return 'Settigns';
    }
  }

  Color _getBackgroundColor({
    required TabType tabType,
  }) {
    switch (tabType) {
      case TabType.tvShows:
        return AppColors.primary;
      case TabType.actors:
        return AppColors.green;
      case TabType.settings:
        return AppColors.purple;
    }
  }

  Color _getTextColor({
    required TabType tabType,
    required TabType currentTapType,
  }) {
    switch (tabType) {
      case TabType.tvShows:
        return AppColors.white;
      case TabType.actors:
        return tabType == currentTapType
            ? Colors.grey.shade900
            : AppColors.white;
      case TabType.settings:
        return AppColors.white;
    }
  }

  void _navigate({
    required TabType tabType,
  }) {
    switch (tabType) {
      case TabType.tvShows:
        return getIt<AppNavigationService>().routeToTvShows();
      case TabType.actors:
        return getIt<AppNavigationService>().routeToActors();
      case TabType.settings:
        getIt<AppNavigationService>().routeToSettings();
    }
  }

  String _getIconPath({
    required TabType tabType,
    required bool isSelected,
  }) {
    if (isSelected) {
      switch (tabType) {
        case TabType.tvShows:
          return AssetSvgsHelper.tvShowsSolid;
        case TabType.actors:
          return AssetSvgsHelper.actorsSolid;
        case TabType.settings:
          return AssetSvgsHelper.settingsSolid;
      }
    }
    switch (tabType) {
      case TabType.tvShows:
        return AssetSvgsHelper.tvShows;
      case TabType.actors:
        return AssetSvgsHelper.actors;
      case TabType.settings:
        return AssetSvgsHelper.settings;
    }
  }
}