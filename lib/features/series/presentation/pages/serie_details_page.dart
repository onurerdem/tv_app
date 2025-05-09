import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tv_app/features/series/presentation/bloc/serie_details_event.dart';
import 'package:tv_app/features/series/presentation/widgets/show_episode_details.dart';
import 'package:tv_app/injection_container.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/serie_details_bloc.dart';
import '../bloc/serie_details_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SerieDetailsPage extends StatelessWidget {
  final int serieId;

  const SerieDetailsPage({super.key, required this.serieId});

  Future<void> _launchURL(BuildContext context, String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL not available')),
      );
      return;
    }
    final Uri? uri = Uri.tryParse(urlString);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not parse URL: $urlString')),
      );
      return;
    }

    if (await canLaunchUrl(uri)) {
      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<SerieDetailsBloc>()..add(GetSerieDetailsEvent(serieId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Serie Details"),
        ),
        body: BlocBuilder<SerieDetailsBloc, SerieDetailsState>(
          builder: (context, state) {
            if (state is SerieDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SerieDetailsLoaded) {
              Widget buildSeasonButtons() {
                final seasons = state.availableSeasons;
                if (seasons.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Wrap(
                  spacing: 4.0,
                  children: [
                    ActionChip(
                      label: const Text("All"),
                      backgroundColor: state.selectedSeason == null
                          ? Theme.of(context).chipTheme.selectedColor ??
                              Theme.of(context).colorScheme.primary
                          : Theme.of(context).chipTheme.backgroundColor,
                      labelStyle: TextStyle(
                        color: state.selectedSeason == null
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).chipTheme.labelStyle?.color,
                      ),
                      onPressed: () {
                        context
                            .read<SerieDetailsBloc>()
                            .add(const SelectSeasonEvent(null));
                      },
                    ),
                    ...seasons.map((season) {
                      final isSelected = state.selectedSeason == season;
                      return ActionChip(
                        label: Text("Season $season"),
                        backgroundColor: isSelected
                            ? Theme.of(context).chipTheme.selectedColor ??
                                Theme.of(context).colorScheme.primary
                            : Theme.of(context).chipTheme.backgroundColor,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).chipTheme.labelStyle?.color,
                        ),
                        onPressed: () {
                          context
                              .read<SerieDetailsBloc>()
                              .add(SelectSeasonEvent(season));
                        },
                      );
                    }),
                  ],
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0)
                          .copyWith(top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          state.serieDetails.imageUrl != null
                              ? Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: CachedNetworkImage(
                                      imageUrl: state.serieDetails.imageUrl!,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        width:
                                            MediaQuery.of(context).size.width / 2,
                                        height: 200,
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        child: SvgPicture.asset(
                                          "assets/images/No-Image-Placeholder.svg",
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width / 2,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: SvgPicture.asset(
                                      "assets/images/No-Image-Placeholder.svg",
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 16),
                          Text(
                            state.serieDetails.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Rating",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.serieDetails.ratingAverage != null
                                ? state.serieDetails.ratingAverage.toString()
                                : "Rating not available.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Summary",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.serieDetails.summary != null
                                ? "${state.serieDetails.summary?.replaceAll(RegExp(r'<[^>]*>'), '')}"
                                : "Explanation not available.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Genres",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.serieDetails.genres.isNotEmpty
                                ? state.serieDetails.genres.join(', ')
                                : "No species information available.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Years of Release",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.serieDetails.premiered != null &&
                                    state.serieDetails.ended != null
                                ? "${state.serieDetails.premiered!.replaceAll('-', '.')} - ${state.serieDetails.ended!.replaceAll('-', '.')}"
                                : (state.serieDetails.premiered != null
                                    ? "${state.serieDetails.premiered!.replaceAll('-', '.')} - Ongoing"
                                    : "Premiered date not available."),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Watch At",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            direction: Axis.vertical,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.cell_tower,
                                    size: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    state.serieDetails.networkName != null
                                        ? state.serieDetails.networkName!
                                        : "No network information available.",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              if (state.serieDetails.officialSite != null &&
                                  state.serieDetails.officialSite!.isNotEmpty)
                                InkWell(
                                  onTap: () => _launchURL(
                                      context, state.serieDetails.officialSite,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.link,
                                          size: 16,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color),
                                      const SizedBox(width: 4),
                                      Text(
                                        state.serieDetails.officialSite!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Colors.blue[700],
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Colors.blue[700],
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.link_off,
                                        size: 16,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Official Site not available.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color),
                                    ),
                                  ],
                                ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_month_outlined,
                                      size: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color),
                                  const SizedBox(width: 4),
                                  Text(
                                    state.serieDetails.scheduleDays.join(', '),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.access_time,
                                      size: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color),
                                  const SizedBox(width: 4),
                                  Text(
                                    state.serieDetails.scheduleTime?.trim() !=
                                            null
                                        ? state.serieDetails.scheduleTime!
                                        : "No time information available.",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Language",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.serieDetails.language != null
                                ? state.serieDetails.language!
                                : "Language not available.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Country",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.serieDetails.networkCountryName != null
                                ? state.serieDetails.networkCountryName! ==
                                        "Turkey"
                                    ? "Türkiye"
                                    : state.serieDetails.networkCountryName!
                                : "Country not available.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Runtime",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.serieDetails.runtime != null
                                ? "${state.serieDetails.runtime.toString()} Minutes"
                                : "Runtime not available.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Average Runtime",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.serieDetails.averageRuntime != null
                                ? "${state.serieDetails.averageRuntime.toString()} Minutes"
                                : "Average runtime not available.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Seasons",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          buildSeasonButtons(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Episodes ${state.selectedSeason != null ? "(Season ${state.selectedSeason})" : "(All)"}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    if (state.filteredEpisodes.isNotEmpty)
                      ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0)
                            .copyWith(bottom: 16.0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: state.filteredEpisodes.length,
                        itemBuilder: (context, index) {
                          final episode = state.filteredEpisodes[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              showEpisodeDetails(context, episode);
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 160,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  child: episode.imageUrl != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: CachedNetworkImage(
                                            imageUrl: episode.imageUrl!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              color: Colors.grey[300],
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              child: SvgPicture.asset(
                                                "assets/images/No-Image-Placeholder.svg",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: SvgPicture.asset(
                                            "assets/images/No-Image-Placeholder.svg",
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
                                        episode.name ?? "Name not available.",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Season ${episode.season}, Episode ${episode.number ?? "Unknown."}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Air Date: ${episode.airdate?.replaceAll('-', '.') ?? "Air Date not available."}, Air Time: ${episode.airtime ?? "Air Time not available."}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Rating: ${episode.ratingAverage ?? "Unknown."}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        episode.summary != null &&
                                                episode.summary!.isNotEmpty
                                            ? "${episode.summary?.replaceAll(RegExp(r'<[^>]*>'), '')}"
                                            : "Explanation not available.",
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 24.0,
                        ),
                        child: Center(
                          child: Text(
                            "No episodes found for the selected season.",
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else if (state is SerieDetailsError) {
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
