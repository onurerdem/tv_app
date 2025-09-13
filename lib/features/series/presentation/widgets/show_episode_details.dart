import 'package:flutter/material.dart';
import 'package:tv_app/features/series/domain/entities/episode.dart';
import 'package:tv_app/features/series/presentation/widgets/episode_detail_sheet_content.dart';
import '../../domain/entities/series.dart';

void showEpisodeDetails(BuildContext context, Episode episode, Series serie) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      behavior: HitTestBehavior.opaque,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (context, scrollController) {
          return GestureDetector(
            onTap: () {},
            child: EpisodeDetailSheetContent(
              episode: episode,
              serie: serie,
              scrollController: scrollController,
            ),
          );
        },
      ),
    ),
  );
}
