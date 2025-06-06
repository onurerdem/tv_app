import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:tv_app/features/series/domain/usecases/get_episodes.dart';
import 'package:tv_app/features/series/domain/usecases/get_serie_details.dart';
import 'package:tv_app/features/series/presentation/bloc/serie_details_bloc.dart';
import 'package:tv_app/features/series/presentation/bloc/serie_details_event.dart';
import 'package:tv_app/features/series/presentation/pages/serie_details_page.dart';
import 'package:tv_app/injection_container.dart';
import '../bloc/serie_favorites_bloc.dart';

class SerieFavoritesPage extends StatefulWidget {
  const SerieFavoritesPage({super.key});

  @override
  State<SerieFavoritesPage> createState() => _SerieFavoritesPageState();
}

class _SerieFavoritesPageState extends State<SerieFavoritesPage> {
  late SerieFavoritesBloc favoritesBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    favoritesBloc = sl<SerieFavoritesBloc>()..add(LoadSerieFavorites());
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _refreshData() async {
    favoritesBloc = sl<SerieFavoritesBloc>()..add(LoadSerieFavorites());
    _searchController.addListener(_onSearchChanged);
    context.read<SerieFavoritesBloc>().loadInitialFavorites();
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
    favoritesBloc.add(SearchSerieFavorites(query));
  }

  @override
  Widget build(BuildContext context) {
    final di = GetIt.instance;

    return BlocProvider.value(
      value: favoritesBloc,
      child: PopScope(
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          context.read<SerieFavoritesBloc>().loadInitialFavorites();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Favorite Series"),
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
                      labelText: 'Search for favorite series...',
                      floatingLabelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          favoritesBloc.add(
                            SearchSerieFavorites(_searchController.text.trim()),
                          );
                          context
                              .read<SerieFavoritesBloc>()
                              .loadInitialFavorites();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          favoritesBloc.add(
                            SearchSerieFavorites(_searchController.text = ""),
                          );
                          context
                              .read<SerieFavoritesBloc>()
                              .loadInitialFavorites();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    onChanged: (query) {
                      favoritesBloc.add(
                        SearchSerieFavorites(query.trim()),
                      );
                    },
                    textInputAction: TextInputAction.search,
                    onSubmitted: (query) {
                      favoritesBloc.add(
                        SearchSerieFavorites(query.trim()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: BlocBuilder<SerieFavoritesBloc, SerieFavoritesState>(
                      builder: (context, state) {
                        if (state is SerieFavoritesLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is SerieFavoritesLoaded) {
                          if (state.allFavorites.isEmpty) {
                            return const Center(
                                child: Text("No favorites yet."));
                          }
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                            const Divider(),
                            itemCount: state.allFavorites.length,
                            itemBuilder: (context, index) {
                              final series = state.allFavorites[index];

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
                                      .read<SerieFavoritesBloc>()
                                      .add(LoadSerieFavorites());
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
                                    //const SizedBox(width: 0),
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
                                              ? 'Remove to favorites'
                                              : 'Add to favorites.',
                                          onPressed: () {
                                            if (isCurrentlyFavorited) {
                                              context
                                                  .read<SerieFavoritesBloc>()
                                                  .add(RemoveSerieFromFavorites(
                                                  series));
                                            } else {
                                              context
                                                  .read<SerieFavoritesBloc>()
                                                  .add(AddSerieToFavorites(
                                                  series));
                                            }
                                          },
                                        );
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (state is SerieFavoritesError) {
                          return Center(child: Text(state.message));
                        }
                        return const Center(
                          child: Text("Favorite series could not be loaded."),
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
