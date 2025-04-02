import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../bloc/serie_details_bloc.dart';
import '../bloc/serie_details_state.dart';

class SerieDetailPage extends StatelessWidget {
  final int serieId;

  const SerieDetailPage({super.key, required this.serieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    state.serieDetails.imageUrl != null
                        ? Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.network(
                                state.serieDetails.imageUrl!,
                                width: MediaQuery.of(context).size.width / 2,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: SvgPicture.asset(
                              "assets/images/No-Image-Placeholder.svg",
                              width: MediaQuery.of(context).size.width / 2,
                              fit: BoxFit.cover,
                            ),
                          ),
                    const SizedBox(height: 16),
                    Text(
                      state.serieDetails.name,
                      style: Theme.of(context).textTheme.titleLarge,
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
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Text(
                          state.serieDetails.network != null
                              ? state.serieDetails.network!
                              : "No network information available.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          state.serieDetails.scheduleDays.join(', '),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          state.serieDetails.scheduleTime?.trim() != null
                              ? state.serieDetails.scheduleTime!
                              : "No time information available.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
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
    );
  }
}
