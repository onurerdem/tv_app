import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tv_app/features/series/domain/entities/episode.dart';
import '../../../watched/presentation/bloc/watched_bloc.dart';
import '../../../watched/presentation/bloc/watched_event.dart';
import '../../../watched/presentation/bloc/watched_state.dart';
import '../../domain/entities/series.dart';

class EpisodeDetailSheetContent extends StatelessWidget {
  final Episode episode;
  final Series serie;
  final ScrollController scrollController;

  const EpisodeDetailSheetContent({
    super.key,
    required this.episode,
    required this.serie,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 1,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Scaffold(
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            primary: false,
            automaticallyImplyLeading: false,
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(-10.0),
              child: Container(
                height: 4.0,
                width: 40.0,
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[800],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (episode.imageUrl != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: CachedNetworkImage(
                                imageUrl: episode.imageUrl!,
                                width: MediaQuery.of(context).size.width / 1.5,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: SvgPicture.asset(
                                    "assets/images/No-Image-Placeholder.svg",
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            BlocSelector<WatchedBloc, WatchedState, bool>(
                              selector: (watchedState) {
                                if (watchedState is WatchedLoaded) {
                                  return watchedState
                                          .watchedEpisodesMap[episode.id] ??
                                      false;
                                }
                                return false;
                              },
                              builder: (context, isWatched) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.check_circle,
                                    color:
                                        isWatched ? Colors.green : Colors.grey,
                                  ),
                                  tooltip: isWatched
                                      ? 'Unmark episode as watched'
                                      : 'Mark episode as watched',
                                  onPressed: () {
                                    context.read<WatchedBloc>().add(
                                          ToggleEpisodeWatched(
                                            serie.id,
                                            episode.id,
                                          ),
                                        );
                                  },
                                );
                              },
                            ),
                          ],
                        )
                      else
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: SvgPicture.asset(
                              "assets/images/No-Image-Placeholder.svg",
                              width: MediaQuery.of(context).size.width / 2,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Text(
                        episode.name ?? "Name not available",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Season ${episode.season}, Episode ${episode.number ?? "Unknown."}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Air Date",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${episode.airdate?.replaceAll('-', '.') ?? "Air date not available."}, Air Time: ${episode.airtime ?? "Air time not available."}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Run Time",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${episode.runtime ?? "Unknown"} Minutes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Rating",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${episode.ratingAverage ?? "Unknown."}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Summary",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        episode.summary != null && episode.summary!.isNotEmpty
                            ? episode.summary!
                            .replaceAll(RegExp(r'<[^>]*>'), '')
                            .trim()
                            : "Summary not available.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                    ],
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
