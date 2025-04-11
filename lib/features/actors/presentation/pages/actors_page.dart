import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import '../../domain/usecases/get_actor_cast_credits_usecase.dart';
import '../../domain/usecases/get_actor_details_usecase.dart';
import '../bloc/actor_details_bloc.dart';
import '../bloc/actor_details_event.dart';
import '../bloc/actors_bloc.dart';
import '../bloc/actors_event.dart';
import '../bloc/actors_state.dart';
import 'actor_details_page.dart';

class ActorsPage extends StatefulWidget {
  const ActorsPage({super.key});

  @override
  State<ActorsPage> createState() => _ActorsPageState();
}

class _ActorsPageState extends State<ActorsPage> {
  late ActorsBloc bloc;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = context.read<ActorsBloc>();
    bloc.add(GetAllActorsEvent());
  }

  Future<void> _refreshData() async {
    bloc = context.read<ActorsBloc>();
    bloc.add(GetAllActorsEvent());
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ActorsBloc>();
    final di = GetIt.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Actors"),
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
                  labelText: "Search for actors.",
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      bloc.add(
                        SearchActorsQueryEvent(_controller.text.trim()),
                      );
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
                onChanged: (query) {
                  bloc.add(SearchActorsQueryEvent(query.trim()));
                },
                textInputAction: TextInputAction.search,
                onSubmitted: (query) {
                  bloc.add(
                    SearchActorsQueryEvent(query.trim()),
                  );
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<ActorsBloc, ActorsState>(
                  builder: (context, state) {
                    if (state is ActorsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ActorsLoaded) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: state.actors.length,
                        itemBuilder: (context, index) {
                          final actor = state.actors[index];
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
                                  child: actor.imageUrl != null ? ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child: Image.network(
                                            actor.imageUrl!,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width / 3.9,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child: SvgPicture.asset(
                                            "assets/images/No-Image-Placeholder.svg",
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width / 3.9,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        actor.fullName,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        actor.country == "Turkey"
                                            ? "Türkiye"
                                            : actor.country
                                            ?? "Unknown country",
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
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is ActorsError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(
                        child: Text("Enter a term to search for a actor."));
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
