import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/core/dependencies/dependencies.dart';
import 'package:tv_app/core/design_system/widgets/fields/search_field_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/error_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/loading_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/bottom_app_bar_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/main_header_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/main_scaffold_widget.dart';
import 'package:tv_app/core/design_system/widgets/pagination/infinity_scroll_pagination_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/header_text_widget.dart';
import 'package:tv_app/core/navigation/services/navigation_service.dart';
import 'package:tv_app/features/tv_shows/presentation/widgets/tv_show_card_widget.dart';
import 'package:tv_app/features/tv_shows/state/tv_shows/tv_shows_cubit.dart';
import 'package:tv_app/features/tv_shows/state/tv_shows/tv_show_state.dart';

class TvShowsScreen extends StatefulWidget {
  const TvShowsScreen({super.key});

  @override
  State<TvShowsScreen> createState() => _TvShowsScreenState();
}

class _TvShowsScreenState extends State<TvShowsScreen> {
  String _seachText = '';

  @override
  Widget build(BuildContext context) {
    return UIMainScaffold(
      canPop: false,
      mainHeader: UIMainHeader(
        height: 205,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UIHeaderText(
              'Tv Shows',
              fontSize: 32,
            ),
            const SizedBox(height: 8),
            UISearchField(
              onSearchChanged: (String text) {
                _seachText = text.trim();
                context.read<TvShowsCubit>().getTvShows(
                      search: _seachText.isEmpty ? null : _seachText,
                    );
              },
              placeHolder: 'Search Tv Shows',
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      body: BlocBuilder<TvShowsCubit, TvShowsState>(
        builder: (BuildContext context, TvShowsState state) {
          if (state is TvShowsLoadedState) {
            return UIInfinityScrollPagination(
              topExtraSpace: 196,
              bottomExtraSpace: 100,
              itemsLenght: state.tvShows.length,
              itemBuilder: (BuildContext context, int index) => TvShowCard(
                onPressed: () =>
                    getIt<AppNavigationService>().routeToSelectedTvShow(
                  tvShowId: state.tvShows[index].id,
                ),
                tvShow: state.tvShows[index],
              ),
              onFetchMore: context.read<TvShowsCubit>().getTvShowsNextPage,
              hasNextPage: state.hasNextPage,
            );
          }
          if (state is TvShowsErrorState) {
            return Padding(
              padding: const EdgeInsets.only(top: 200),
              child: UIErrorIndicator(
                errorText:
                    'Failed to load tv shows, please check your internet connection.',
                onPressed: () => context.read<TvShowsCubit>().getTvShows(
                      search: _seachText.isEmpty ? null : _seachText,
                    ),
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.only(top: 80),
            child: UILoadingIndicator(),
          );
        },
      ),
      bottomAppBar: const UIBottomAppBar(
        currentTab: TabType.tvShows,
      ),
    );
  }
}