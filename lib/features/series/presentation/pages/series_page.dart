import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:tv_app/features/serie_favorites/presentation/bloc/serie_favorites_bloc.dart';
import 'package:tv_app/features/serie_favorites/presentation/pages/serie_favorites_page.dart';
import 'package:tv_app/features/series/domain/usecases/get_episodes.dart';
import 'package:tv_app/features/series/presentation/pages/serie_details_page.dart';
import '../../../watched/presentation/bloc/watched_bloc.dart';
import '../../../watched/presentation/bloc/watched_event.dart';
import '../../../watched/presentation/bloc/watched_state.dart';
import '../../../watched/presentation/pages/watched_page.dart';
import '../../../watched/presentation/widgets/show_watched_dialog.dart';
import '../../../watchlist/presentation/bloc/watchlist_bloc.dart';
import '../../../watchlist/presentation/bloc/watchlist_event.dart';
import '../../../watchlist/presentation/bloc/watchlist_state.dart';
import '../../../watchlist/presentation/pages/watchlist_page.dart';
import '../../domain/usecases/get_serie_details.dart';
import '../bloc/serie_details_bloc.dart';
import '../bloc/serie_details_event.dart';
import '../bloc/series_bloc.dart';
import '../bloc/series_event.dart';
import '../bloc/series_state.dart';

class SeriesPage extends StatefulWidget {
  final String uid;
  const SeriesPage({super.key, required this.uid});

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  late SeriesBloc bloc;
  final TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc = context.read<SeriesBloc>();
    bloc.add(FetchSeriesEvent());
    context.read<SerieFavoritesBloc>().loadInitialFavorites();
    context.read<WatchlistBloc>().add(LoadWatchlist());
    _scrollController.addListener(_onScroll);
  }

  Future<void> _refreshData() async {
    bloc = context.read<SeriesBloc>();
    bloc.add(GetAllSeriesEvent());
    context.read<SerieFavoritesBloc>().loadInitialFavorites();
    context.read<WatchlistBloc>().add(LoadWatchlist());
    FocusScope.of(context).unfocus();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      bloc.add(FetchSeriesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SeriesBloc>();
    final di = GetIt.instance;
    final favoritesBloc = context.read<SerieFavoritesBloc>();
    final watchlistBloc = context.read<WatchlistBloc>();
    final watchedBloc = context.read<WatchedBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Series'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            tooltip: 'View favorites.',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) => BlocProvider.value(
                    value: context.read<SerieFavoritesBloc>()
                      ..add(LoadSerieFavorites()),
                    child: const SerieFavoritesPage(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.blue,
            ),
            tooltip: 'View watchlist.',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) => BlocProvider.value(
                    value: context.read<WatchlistBloc>()..add(LoadWatchlist()),
                    child: const WatchlistPage(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            tooltip: 'View watched series.',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) => BlocProvider.value(
                    value: context.read<WatchedBloc>(),
                    child: const WatchedPage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Search for series.',
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      bloc.add(
                        SearchSeriesQuery(_controller.text.trim()),
                      );
                      context.read<SerieFavoritesBloc>().loadInitialFavorites();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      bloc.add(
                        SearchSeriesQuery(_controller.text = ""),
                      );
                      context.read<SerieFavoritesBloc>().loadInitialFavorites();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                onChanged: (query) {
                  bloc.add(
                    SearchSeriesQuery(query.trim()),
                  );
                },
                textInputAction: TextInputAction.search,
                onSubmitted: (query) {
                  bloc.add(
                    SearchSeriesQuery(query.trim()),
                  );
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<SeriesBloc, SeriesState>(
                  builder: (context, state) {
                    if (state is SeriesLoaded) {
                      if (state.seriesList.isEmpty &&
                          _controller.text.isNotEmpty) {
                        return const Center(
                            child: Text("No series found for your search."));
                      }
                      if (state.seriesList.isEmpty &&
                          _controller.text.isEmpty) {
                        return const Center(
                            child: Text(
                                "Enter a term to search or pull to refresh."));
                      }
                      return ListView.separated(
                        controller: _scrollController,
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: state.seriesList.length +
                            (state.hasReachedMax ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index >= state.seriesList.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final series = state.seriesList[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.push(
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
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Rating: ${series.ratingAverage != null ? series.ratingAverage.toString() : "Rating not available."}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        series.summary != null
                                            ? "${series.summary?.replaceAll(RegExp(r'<[^>]*>'), '')}"
                                            : "Explanation not available.",
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        series.genres.isNotEmpty
                                            ? series.genres.join(', ')
                                            : "No species information available.",
                                        style: const TextStyle(fontSize: 12),
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
                                              favoritesBloc.add(
                                                  RemoveSerieFromFavorites(
                                                      series));
                                            } else {
                                              favoritesBloc.add(
                                                  AddSerieToFavorites(series));
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    BlocBuilder<WatchlistBloc, WatchlistState>(
                                      builder: (
                                          context,
                                          watchlistState,
                                          ) {
                                        final isInWatchlist = watchlistBloc
                                            .state is WatchlistLoaded &&
                                            (watchlistBloc.state
                                            as WatchlistLoaded)
                                                .serieIds
                                                .contains(series.id);

                                        return IconButton(
                                          icon: Icon(
                                            Icons.bookmark,
                                            color: isInWatchlist
                                                ? Colors.blue
                                                : Colors.grey,
                                          ),
                                          tooltip: isInWatchlist
                                              ? 'Remove from watchlist.'
                                              : 'Add to watchlist.',
                                          onPressed: () {
                                            if (isInWatchlist) {
                                              watchlistBloc.add(
                                                RemoveSerieFromWatchlist(
                                                  series,
                                                ),
                                              );
                                            } else {
                                              watchlistBloc.add(
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
                                        final isInWatchedSeries = watchedBloc
                                            .state is WatchedLoaded &&
                                            (watchedBloc.state as WatchedLoaded)
                                                .serieIds
                                                .contains(series.id);

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
                                                  ScaffoldMessenger.of(context)
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

                                                  final episodeIds = episodes
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
                                                  ScaffoldMessenger.of(context)
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

                                                  final episodeIds = episodes
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
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is SeriesError) {
                      return Center(child: Text(state.message));
                    } else if (state is SeriesInitial ||
                        state is SeriesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const Center(
                      child: Text("Enter a term to search for a serie."),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
