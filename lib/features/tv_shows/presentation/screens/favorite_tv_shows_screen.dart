import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/core/dependencies/dependencies.dart';
import 'package:tv_app/core/design_system/helpers/asset_svgs_helper.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/back_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/buttons/button_widget.dart';
import 'package:tv_app/core/design_system/widgets/buttons/icon_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/empty_list_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/error_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/loading_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/main_scaffold_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/header_text_widget.dart';
import 'package:tv_app/core/event_bus/event_bus_service.dart';
import 'package:tv_app/core/navigation/services/dialogs_service.dart';
import 'package:tv_app/core/navigation/services/navigation_service.dart';
import 'package:tv_app/features/tv_shows/data/repositories/local_tv_shows_repository.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';
import 'package:tv_app/features/tv_shows/presentation/widgets/tv_show_card_widget.dart';
import 'package:tv_app/features/tv_shows/state/favorite_tv_shows/favorite_tv_shows_cubit.dart';
import 'package:tv_app/features/tv_shows/state/favorite_tv_shows/favorite_tv_shows_state.dart';
import 'package:tv_app/features/tv_shows/state/favorite_tv_shows_crud/favorite_tv_shows_crud_cubit.dart';
import 'package:tv_app/features/tv_shows/state/favorite_tv_shows_crud/favorite_tv_shows_crud_state.dart';

class FavoriteTvShowsScreen extends StatefulWidget {
  const FavoriteTvShowsScreen({super.key});

  @override
  State<FavoriteTvShowsScreen> createState() => _FavoriteTvShowsScreenState();
}

class _FavoriteTvShowsScreenState extends State<FavoriteTvShowsScreen> {
  bool isEditEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteTvShowsCubit, FavoriteTvShowsState>(
      builder: (BuildContext context, FavoriteTvShowsState state) {
        return UIMainScaffold(
          backButton: const UIBackButton(
            color: AppColors.primary,
          ),
          actionButton: isEditEnabled &&
                  state is FavoriteTvShowsLoadedState &&
                  state.tvShows.isNotEmpty
              ? UIButton(
                  text: 'Done',
                  horizontalPadding: 12,
                  onPressed: () => setState(() => isEditEnabled = false),
                  fontSize: 14,
                  height: 40,
                )
              : null,
          actionIconButton1: !isEditEnabled &&
                  state is FavoriteTvShowsLoadedState &&
                  state.tvShows.isNotEmpty
              ? UIIconButton(
                  backgroundColor: AppColors.primary,
                  onPressed: () => setState(() => isEditEnabled = true),
                  svgIconPath: AssetSvgsHelper.edit,
                  iconSize: 18,
                )
              : null,
          body: Builder(builder: (BuildContext context) {
            if (state is FavoriteTvShowsLoadedState) {
              return ListView(
                key: UniqueKey(),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 100,
                  top: 70,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(
                    hasSavedClassses: state.tvShows.isNotEmpty,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildFavoriteTvShows(
                    tvShows: state.tvShows,
                  ),
                ],
              );
            }
            if (state is FavoriteTvShowsErrorState) {
              return UIErrorIndicator(
                errorText: 'Failed to load your favorite tv shows.',
                onPressed: () =>
                    context.read<FavoriteTvShowsCubit>().getFavoriteTvShows(),
              );
            }
            return const UILoadingIndicator();
          }),
        );
      },
    );
  }

  Widget _buildHeader({
    required bool hasSavedClassses,
  }) =>
      const UIHeaderText(
        'Favorite Tv Shows',
        fontSize: 32,
      );

  Widget _buildFavoriteTvShows({
    required List<ITvShow> tvShows,
  }) {
    if (tvShows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 80),
        child: UIEmptyListIndicator(
          text: 'You have not added any tv shows to your favotire list yet.',
        ),
      );
    }
    return Column(
      children: List.generate(
        tvShows.length,
        (int index) => BlocProvider(
          create: (BuildContext context) => FavoriteTvShowsCrudCubit(
            localTvShowsRepository: getIt<LocalTvShowsRepository>(),
            eventBus: getIt<EventBus>(),
          ),
          child:
              BlocBuilder<FavoriteTvShowsCrudCubit, FavoriteTvShowsCrudState>(
            builder:
                (BuildContext innerContext, FavoriteTvShowsCrudState state) {
              return TvShowCard(
                key: Key(tvShows[index].id),
                iconButton: isEditEnabled
                    ? UIIconButton(
                        backgroundColor: AppColors.primary,
                        onPressed: () => _removeFavoriteTvShow(
                          tvShowId: tvShows[index].id,
                        ),
                        isLoading: state is FavoriteTvShowsCrudLoadingState,
                        svgIconPath: AssetSvgsHelper.delete,
                        iconSize: 20,
                      )
                    : null,
                onPressed: () {
                  if (!isEditEnabled) {
                    getIt<AppNavigationService>().routeToSelectedTvShow(
                      tvShowId: tvShows[index].id,
                    );
                  }
                },
                tvShow: tvShows[index],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _removeFavoriteTvShow({
    required String tvShowId,
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