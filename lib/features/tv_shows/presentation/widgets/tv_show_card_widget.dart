import 'package:flutter/material.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';

class TvShowCard extends StatelessWidget {
  const TvShowCard({
    required this.tvShow,
    super.key,
  });

  final ITvShow tvShow;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}