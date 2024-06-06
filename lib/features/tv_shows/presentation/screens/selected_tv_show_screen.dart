import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/core/dependencies/dependencies.dart';
import 'package:tv_app/core/design_system/helpers/asset_svgs_helper.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/back_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/buttons/icon_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/error_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/loading_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/main_scaffold_widget.dart';
import 'package:tv_app/core/navigation/services/dialogs_service.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';
import 'package:tv_app/features/tv_shows/presentation/widgets/tv_show_content_widget.dart';
import 'package:tv_app/features/tv_shows/state/favorite_tv_shows_crud/favorite_tv_shows_crud_cubit.dart';
import 'package:tv_app/features/tv_shows/state/favorite_tv_shows_crud/favorite_tv_shows_crud_state.dart';
import 'package:tv_app/features/tv_shows/state/selected_tv_show/selected_tv_show_cubit.dart';
import 'package:tv_app/features/tv_shows/state/selected_tv_show/selected_tv_show_state.dart';

class SelectedTvShowScreen extends StatelessWidget {
  const SelectedTvShowScreen({
    required this.tvShowId,
    super.key,
  });

  final String tvShowId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedTvShowCubit, SelectedTvShowState>(builder: (
      BuildContext context,
      SelectedTvShowState selectedTvShowState,
    ) {
      return BlocBuilder<FavoriteTvShowsCrudCubit, FavoriteTvShowsCrudState>(
        builder: (context, FavoriteTvShowsCrudState favoriteTvShowsCrudState) {
          return UIMainScaffold(
            backButton: const UIBackButton(
              color: AppColors.primary,
            ),
            actionIconButton1: selectedTvShowState is SelectedTvShowLoadedState
                ? UIIconButton(
                    backgroundColor: AppColors.primary,
                    onPressed: () {
                      if (selectedTvShowState.isFavorite) {
                        _removeFavoriteTvShow(
                          tvShowId: tvShowId,
                          context: context,
                        );
                      } else {
                        _addFavoriteTvShow(
                            context: context,
                            tvShow: selectedTvShowState.tvShow);
                      }
                    },
                    isLoading: favoriteTvShowsCrudState
                        is FavoriteTvShowsCrudLoadingState,
                    svgIconPath: selectedTvShowState.isFavorite
                        ? AssetSvgsHelper.bookmarkAdded
                        : AssetSvgsHelper.bookmarkAdd,
                  )
                : null,
            body: Builder(
              builder: (BuildContext context) {
                if (selectedTvShowState is SelectedTvShowLoadedState) {
                  return TvShowContent(
                    tvShow: selectedTvShowState.tvShow,
                  );
                }
                if (selectedTvShowState is SelectedTvShowErrorState) {
                  return Center(
                    child: UIErrorIndicator(
                      errorText:
                          'Failed to load tv show, please check your internet connection.',
                      onPressed: () =>
                          context.read<SelectedTvShowCubit>().getTvShow(
                                tvShowId: tvShowId,
                              ),
                    ),
                  );
                }
                return const Center(
                  child: UILoadingIndicator(),
                );
              },
            ),
          );
        },
      );
    });
  }

  Future<void> _addFavoriteTvShow({
    required ITvShow tvShow,
    required BuildContext context,
  }) async {
    FavoriteTvShowsCrudState favoriteTvShowsCrudState =
        await context.read<FavoriteTvShowsCrudCubit>().addFavoriteTvShow(
              tvShow: tvShow,
            );
    if (favoriteTvShowsCrudState is FavoriteTvShowsCrudErrorState) {
      getIt<AppDialogsService>().showErrorDialog(
        text: 'Failed to save this tv show to yuor favorites.',
      );
    }
  }

  Future<void> _removeFavoriteTvShow({
    required String tvShowId,
    required BuildContext context,
  }) async {
    getIt<AppDialogsService>().showConfirmationDialog(
      title: 'Remove Tv Show',
      text:
          'Are you sure that you want to remove this tv show from your favorites?',
      onConfirmation: () async {
        FavoriteTvShowsCrudState favoriteTvShowsCrudState =
            await context.read<FavoriteTvShowsCrudCubit>().removeFavoriteTvShow(
                  tvShowId: tvShowId,
                );
        if (favoriteTvShowsCrudState is FavoriteTvShowsCrudErrorState) {
          getIt<AppDialogsService>().showErrorDialog(
            text: 'Failed to remove this tv show from your favorite.',
          );
        }
      },
    );
  }
}