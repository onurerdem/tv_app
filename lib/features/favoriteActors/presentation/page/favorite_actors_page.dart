import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import '../../../actors/domain/usecases/get_actor_cast_credits_usecase.dart';
import '../../../actors/domain/usecases/get_actor_details_usecase.dart';
import '../../../actors/presentation/bloc/actor_details_bloc.dart';
import '../../../actors/presentation/bloc/actor_details_event.dart';
import '../../../actors/presentation/pages/actor_details_page.dart';
import '../bloc/favorite_actors_bloc.dart';
import '../bloc/favorite_actors_event.dart';
import '../bloc/favorite_actors_state.dart';

class FavoriteActorsPage extends StatefulWidget {
  const FavoriteActorsPage({super.key});

  @override
  State<FavoriteActorsPage> createState() => _FavoriteActorsPageState();
}

class _FavoriteActorsPageState extends State<FavoriteActorsPage> {
  late FavoriteActorsBloc favoriteActorsBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    favoriteActorsBloc = context.read<FavoriteActorsBloc>();
    favoriteActorsBloc.add(LoadFavoritesEvent());
  }

  Future<void> _refreshData() async {
    favoriteActorsBloc = context.read<FavoriteActorsBloc>();
    favoriteActorsBloc.add(LoadFavoritesEvent());
    context.read<FavoriteActorsBloc>().add(LoadFavoritesEvent());
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
    favoriteActorsBloc.add(SearchFavoriteActors(query));
  }

  @override
  Widget build(BuildContext context) {
    final di = GetIt.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Actors")),
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
                  labelText: "Search for favorite actors.",
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      favoriteActorsBloc.add(
                        SearchFavoriteActors(_searchController.text.trim()),
                      );
                      context
                          .read<FavoriteActorsBloc>()
                          .add(LoadFavoritesEvent());
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      favoriteActorsBloc.add(
                        SearchFavoriteActors(_searchController.text = ""),
                      );
                      context
                          .read<FavoriteActorsBloc>()
                          .add(LoadFavoritesEvent());
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                onChanged: (query) {
                  favoriteActorsBloc.add(
                    SearchFavoriteActors(query.trim()),
                  );
                },
                textInputAction: TextInputAction.search,
                onSubmitted: (query) {
                  favoriteActorsBloc.add(
                    SearchFavoriteActors(query.trim()),
                  );
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocConsumer<FavoriteActorsBloc, FavoriteActorsState>(
                  listener: (context, state) {
                    if (state is FavoritesError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${state.message}")),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is FavoritesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FavoritesLoaded) {
                      final actors = state.favoriteActors;
                      if (actors.isEmpty) {
                        return const Center(
                          child: Text("No favorite actors yet."),
                        );
                      }
                      return ListView.separated(
                        itemCount: actors.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final actor = actors[index];

                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (context) => ActorDetailsBloc(
                                      di<GetActorDetailsUseCase>(),
                                      di<GetActorCastCreditsUseCase>(),
                                    )..add(
                                        GetActorDetailsEvent(actor.id),
                                      ),
                                    child: ActorDetailsPage(actorId: actor.id),
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 160,
                                  child: actor.imageUrl != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: Image.network(
                                            actor.imageUrl!,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.9,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    ClipRRect(
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
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.9,
                                                height: 160,
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                  ),
                                                ),
                                              );
                                            },
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
                                        actor.fullName,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        actor.country == "Turkey"
                                            ? "Türkiye"
                                            : actor.country ??
                                                "Unknown country",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        actor.gender ?? "Unknown gender",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "${actor.deathday == null ? "Age" : "Aged"} ${actor.age?.toString() ?? "N/A"}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "${actor.birthday == null ? "Unknown birthday" : actor.birthday.toString().substring(0, 10).replaceAll('-', '.')}${actor.deathday != null ? " - ${actor.deathday.toString().substring(0, 10).replaceAll('-', '.')}" : ""}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                BlocBuilder<FavoriteActorsBloc,
                                    FavoriteActorsState>(
                                  builder: (context, favState) {
                                    final bloc =
                                        context.read<FavoriteActorsBloc>();
                                    final isFav =
                                        (favState is FavoritesLoaded &&
                                            favState.favoriteActors
                                                .contains(actor));
                                    return IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: isFav ? Colors.red : Colors.grey,
                                      ),
                                      tooltip: isFav
                                          ? 'Remove to favorites'
                                          : 'Add to favorites.',
                                      onPressed: () {
                                        if (isFav) {
                                          bloc.add(
                                            RemoveFromFavoritesEvent(actor),
                                          );
                                        } else {
                                          bloc.add(
                                            AddToFavoritesEvent(actor),
                                          );
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
                    } else if (state is FavoritesError) {
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
    );
  }
}
