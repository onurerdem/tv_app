import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:tv_app/features/series/presentation/pages/serie_details_page.dart';
import '../../../serie_favorites/presentation/bloc/serie_favorites_bloc.dart';
import '../../../serie_favorites/presentation/pages/serie_favorites_page.dart';
import '../../domain/usecases/get_episodes.dart';
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
    _scrollController.addListener(_onScroll);
  }

  Future<void> _refreshData() async {
    bloc = context.read<SeriesBloc>();
    bloc.add(GetAllSeriesEvent());
    context.read<SerieFavoritesBloc>().loadInitialFavorites();
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
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
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        bloc.add(
                          SearchSeriesQuery(_controller.text = ""),
                        );
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
                      if (state is SeriesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is SeriesLoaded) {
                        return ListView.separated(
                          controller: _scrollController,
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: state.seriesList.length +
                              (state.hasReachedMax ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (index >= state.seriesList.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
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
                                      child:
                                          SerieDetailsPage(serieId: series.id),
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
                                  BlocBuilder<SerieFavoritesBloc,
                                      SerieFavoritesState>(
                                    builder: (context, favoriteState) {
                                      final isCurrentlyFavorited = (favoriteState
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
                                            ? 'Remove to favorites'
                                            : 'Add to favorites.',
                                        onPressed: () {
                                          if (isCurrentlyFavorited) {
                                            favoritesBloc.add(
                                                RemoveSerieFromFavorites(series));
                                          } else {
                                            favoritesBloc
                                                .add(AddSerieToFavorites(series));
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (state is SeriesError) {
                        return Center(child: Text(state.message));
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
      ),
    );
  }
}
