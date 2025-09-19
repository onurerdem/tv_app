import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:tv_app/features/serie_favorites/presentation/bloc/serie_favorites_bloc.dart';
import 'package:tv_app/features/series/domain/usecases/get_episodes.dart';
import 'package:tv_app/features/series/domain/usecases/get_serie_details.dart';
import 'package:tv_app/features/series/presentation/bloc/serie_details_bloc.dart';
import 'package:tv_app/features/series/presentation/bloc/serie_details_event.dart';
import 'package:tv_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:tv_app/features/watchlist/presentation/bloc/watchlist_event.dart';
import 'package:tv_app/features/watchlist/presentation/bloc/watchlist_state.dart';
import 'package:tv_app/injection_container.dart';
import '../../../series/presentation/pages/serie_details_page.dart';
import '../../../watched/presentation/bloc/watched_bloc.dart';
import '../../../watched/presentation/bloc/watched_event.dart';
import '../../../watched/presentation/bloc/watched_state.dart';
import '../../../watched/presentation/widgets/show_watched_dialog.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  late WatchlistBloc watchlistBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    watchlistBloc = sl<WatchlistBloc>()..add(LoadWatchlist());
    _searchController.addListener(_onSearchChanged);
    context.read<WatchedBloc>().add(LoadWatchedSeries());
  }

  Future<void> _refreshData() async {
    watchlistBloc = sl<WatchlistBloc>()..add(LoadWatchlist());
    _searchController.addListener(_onSearchChanged);
    context.read<WatchlistBloc>().add(LoadWatchlist());
    context.read<WatchedBloc>().add(LoadWatchedSeries());
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    watchlistBloc.add(SearchSerieInWatchlist(query));
  }

  @override
  Widget build(BuildContext context) {
    final di = GetIt.instance;

    return BlocProvider.value(
      value: watchlistBloc,
      child: PopScope(
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          context.read<WatchlistBloc>().add(LoadWatchlist());
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Watchlist"),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Search for a serie in watchlist...',
                      floatingLabelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          watchlistBloc.add(
                            SearchSerieInWatchlist(
                                _searchController.text.trim()),
                          );
                          context.read<WatchlistBloc>().add(LoadWatchlist());
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          watchlistBloc.add(
                            SearchSerieInWatchlist(_searchController.text = ""),
                          );
                          context.read<WatchlistBloc>().add(LoadWatchlist());
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    onChanged: (query) {
                      watchlistBloc.add(
                        SearchSerieInWatchlist(query.trim()),
                      );
                    },
                    textInputAction: TextInputAction.search,
                    onSubmitted: (query) {
                      watchlistBloc.add(
                        SearchSerieInWatchlist(query.trim()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: BlocBuilder<WatchlistBloc, WatchlistState>(
                      builder: (context, state) {
                        if (state is WatchlistLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is WatchlistLoaded) {
                          if (state.allWatchList.isEmpty) {
                            return const Center(
                                child: Text("No watchlist yet."));
                          }
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                            const Divider(),
                            itemCount: state.allWatchList.length,
                            itemBuilder: (context, index) {
                              final series = state.allWatchList[index];

                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider(
                                        create: (context) => SerieDetailsBloc(
                                          di<GetSerieDetails>(),
                                          di<GetEpisodes>(),
                                        )..add(GetSerieDetailsEvent(series.id)),
                                        child: SerieDetailsPage(
                                          serieId: series.id,
                                        ),
                                      ),
                                    ),
                                  );

                                  context
                                      .read<WatchlistBloc>()
                                      .add(LoadWatchlist());
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 160,
                                      child: series.imageUrl != null
                                          ? ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(16.0),
                                        child: Image.network(
                                          series.imageUrl!,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              3.9,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                          : ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(16.0),
                                        child: SvgPicture.asset(
                                          "assets/images/No-Image-Placeholder.svg",
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              3.9,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            series.name,
                                            style:
                                            const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Rating: ${series.ratingAverage != null ? series.ratingAverage.toString() : "Rating not available."}",
                                            style:
                                            const TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            series.summary != null
                                                ? "${series.summary?.replaceAll(RegExp(r'<[^>]*>'), '')}"
                                                : "Explanation not available.",
                                            style:
                                            const TextStyle(fontSize: 12),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            series.genres.isNotEmpty
                                                ? series.genres.join(', ')
                                                : "No species information available.",
                                            style:
                                            const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        BlocBuilder<SerieFavoritesBloc,
                                            SerieFavoritesState>(
                                          builder: (context, favoriteState) {
                                            final isCurrentlyFavorited =
                                            (favoriteState
                                            is SerieFavoritesLoaded &&
                                                favoriteState.favoriteIds
                                                    .contains(series.id));

                                            return IconButton(
                                              icon: Icon(
                                                Icons.favorite,
                                                color: isCurrentlyFavorited
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                              tooltip: isCurrentlyFavorited
                                                  ? 'Remove from favorites.'
                                                  : 'Add to favorites.',
                                              onPressed: () {
                                                if (isCurrentlyFavorited) {
                                                  context.read<SerieFavoritesBloc>().add(
                                                    RemoveSerieFromFavorites(
                                                      series,
                                                    ),
                                                  );
                                                } else {
                                                  context.read<SerieFavoritesBloc>().add(
                                                    AddSerieToFavorites(
                                                      series,
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        ),
                                        BlocBuilder<WatchlistBloc,
                                            WatchlistState>(
                                          builder: (context, watchlistState) {
                                            final isCurrentlyInWatchlist =
                                            (watchlistState
                                            is WatchlistLoaded &&
                                                watchlistState.serieIds
                                                    .contains(series.id));

                                            return IconButton(
                                              icon: Icon(
                                                Icons.bookmark,
                                                color: isCurrentlyInWatchlist
                                                    ? Colors.blue
                                                    : Colors.grey,
                                              ),
                                              tooltip: isCurrentlyInWatchlist
                                                  ? 'Remove from watchlist.'
                                                  : 'Add to watchlist.',
                                              onPressed: () {
                                                if (isCurrentlyInWatchlist) {
                                                  context
                                                      .read<WatchlistBloc>()
                                                      .add(
                                                    RemoveSerieFromWatchlist(
                                                      series,
                                                    ),
                                                  );
                                                } else {
                                                  context
                                                      .read<WatchlistBloc>()
                                                      .add(
                                                    AddSerieToWatchlist(
                                                      series,
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        ),
                                        BlocBuilder<WatchedBloc, WatchedState>(
                                          builder: (context, watchedState) {
                                            final isInWatchedSeries = (watchedState is WatchedLoaded &&
                                                watchedState.serieIds.contains(series.id));

                                            return IconButton(
                                              icon: Icon(
                                                Icons.check_circle,
                                                color: isInWatchedSeries
                                                    ? Colors.green
                                                    : Colors.grey,
                                              ),
                                              tooltip: isInWatchedSeries
                                                  ? 'Remove from watched series.'
                                                  : 'Add to watched series.',
                                              onPressed: () async {
                                                if (isInWatchedSeries) {
                                                  final result =
                                                  await di<GetEpisodes>()
                                                      .call(series.id);
                                                  result.fold(
                                                        (failure) {
                                                      ScaffoldMessenger.of(
                                                          context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            'Episodes could not be loaded',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                        (episodes) async {
                                                      final confirm =
                                                      await showWatchedDialog(
                                                        context,
                                                        series.name,
                                                        'Do you want to mark this serie and its all episodes as unwatched?',
                                                      );
                                                      if (confirm != true) {
                                                        return;
                                                      }

                                                      context
                                                          .read<WatchedBloc>()
                                                          .add(
                                                        RemoveSeriesFromWatched(
                                                          series,
                                                        ),
                                                      );

                                                      final episodeIds =
                                                      episodes
                                                          .map((e) => e.id)
                                                          .toList();
                                                      context
                                                          .read<WatchedBloc>()
                                                          .add(
                                                        RemoveAllEpisodesWatched(
                                                          series,
                                                          episodeIds,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  final result =
                                                  await di<GetEpisodes>()
                                                      .call(series.id);
                                                  result.fold(
                                                        (failure) {
                                                      ScaffoldMessenger.of(
                                                          context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            'Episodes could not be loaded',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                        (episodes) async {
                                                      final confirm =
                                                      await showWatchedDialog(
                                                        context,
                                                        series.name,
                                                        'Do you want to mark this serie and its all episodes as watched?',
                                                      );
                                                      if (confirm != true) {
                                                        return;
                                                      }

                                                      final episodeIds =
                                                      episodes
                                                          .map((e) => e.id)
                                                          .toList();
                                                      context
                                                          .read<WatchedBloc>()
                                                          .add(
                                                        MarkAllEpisodesWatched(
                                                          series.id,
                                                          episodeIds,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (state is WatchlistError) {
                          return Center(child: Text(state.message));
                        }
                        return const Center(
                          child: Text("Watchlist could not be loaded."),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
