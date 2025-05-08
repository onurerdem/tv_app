import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:tv_app/features/series/domain/usecases/get_serie_details.dart';
import 'package:tv_app/features/series/presentation/bloc/serie_details_bloc.dart';
import 'package:tv_app/features/series/presentation/bloc/serie_details_event.dart';
import 'package:tv_app/features/series/presentation/pages/serie_details_page.dart';
import 'package:tv_app/injection_container.dart';
import '../../../series/domain/usecases/get_episodes.dart';
import '../../domain/entities/actor.dart';
import '../bloc/actor_details_bloc.dart';
import '../bloc/actor_details_event.dart';
import '../bloc/actor_details_state.dart';

class ActorDetailsPage extends StatelessWidget {
  final int actorId;

  const ActorDetailsPage({super.key, required this.actorId});

  @override
  Widget build(BuildContext context) {
    TextSpan boldLabelTextSpan(
      String label,
      String? value,
      TextStyle? baseStyle,
    ) {
      return TextSpan(
        style: baseStyle,
        children: <TextSpan>[
          TextSpan(
            text: label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: value ?? 'N/A'),
        ],
      );
    }

    final di = GetIt.instance;

    return BlocProvider(
      create: (_) => sl<ActorDetailsBloc>()..add(GetActorDetailsEvent(actorId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Actor Details'),
        ),
        body: BlocBuilder<ActorDetailsBloc, ActorDetailsState>(
          builder: (context, state) {
            if (state is ActorDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ActorDetailsLoaded) {
              final Actor actor = state.actorDetails;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      actor.imageUrl != null
                          ? Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.network(
                                  actor.imageUrl!,
                                  width: MediaQuery.of(context).size.width / 2,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: SvgPicture.asset(
                                      "assets/images/No-Image-Placeholder.svg",
                                      width: MediaQuery.of(context).size.width / 3.9,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width / 3.9,
                                      height: 160,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: SvgPicture.asset(
                                  "assets/images/No-Image-Placeholder.svg",
                                  width: MediaQuery.of(context).size.width / 2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      const SizedBox(height: 16),
                      RichText(
                        text: boldLabelTextSpan(
                          "Name: ",
                          actor.fullName,
                          Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: boldLabelTextSpan(
                          "Country: ",
                          actor.country == "Turkey"
                              ? "Türkiye"
                              : actor.country ?? "Unknown country",
                          Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: boldLabelTextSpan(
                          "Gender: ",
                          actor.gender ?? 'Unknown gender',
                          Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: boldLabelTextSpan(
                          actor.deathday == null ? "Age: " : "Aged: ",
                          actor.age?.toString() ?? "N/A",
                          Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: boldLabelTextSpan(
                          "Birthdate: ",
                          actor.birthday == null
                              ? "Unknown birthday"
                              : actor.birthday
                                  .toString()
                                  .substring(0, 10)
                                  .replaceAll('-', '.'),
                          Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (actor.deathday != null) ...[
                        const SizedBox(height: 16),
                        RichText(
                          text: boldLabelTextSpan(
                            "Date of death: ",
                            actor.deathday!
                                .toString()
                                .substring(0, 10)
                                .replaceAll('-', '.'),
                            Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text(
                        "Known For",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...state.actorCastCredits.map((actorCastCredits) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (context) => SerieDetailsBloc(
                                        di<GetSerieDetails>(),
                                        di<GetEpisodes>(),
                                      )..add(
                                          GetSerieDetailsEvent(
                                            actorCastCredits.serieId,
                                          ),
                                        ),
                                      child: SerieDetailsPage(
                                        serieId: actorCastCredits.serieId,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 160,
                                    child: actorCastCredits.imageUrl != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(16.0),
                                            child: Image.network(
                                              actorCastCredits.imageUrl!,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width / 3.9,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child: SvgPicture.asset(
                                                  "assets/images/No-Image-Placeholder.svg",
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width / 3.9,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width / 3.9,
                                                  height: 160,
                                                  child: const Center(
                                                      child: CircularProgressIndicator(
                                                              strokeWidth: 2.0,
                                                      ),
                                                  ),
                                                );
                                              },
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
                                        RichText(
                                          text: boldLabelTextSpan(
                                            "Serie: ",
                                            actorCastCredits.serieName,
                                            Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        RichText(
                                          text: boldLabelTextSpan(
                                            "Character: ",
                                            actorCastCredits.characterName ?? "Unknown character",
                                            Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ActorDetailsError) {
              return Center(
                child: Text(state.message),
              );
            }
            return const Center(
              child: Text("No data available."),
            );
          },
        ),
      ),
    );
  }
}
