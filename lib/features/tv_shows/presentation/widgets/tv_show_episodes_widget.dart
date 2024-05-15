import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/cards/label_card_widget.dart';
import 'package:tv_app/core/design_system/widgets/images/network_image_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/divider_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/header_text_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/episode_interface.dart';

class TvShowEpsisodes extends StatefulWidget {
  const TvShowEpsisodes({
    required this.episodes,
    super.key,
  });

  final List<IEpisode> episodes;

  @override
  State<TvShowEpsisodes> createState() => _TvShowEpsisodesState();
}

class _TvShowEpsisodesState extends State<TvShowEpsisodes> {
  late final List<int> _seasons =
      widget.episodes.map((IEpisode e) => e.season).toList().toSet().toList();
  late int _selectedSeason = _seasons.first;

  @override
  Widget build(BuildContext context) {
    List<IEpisode> selectedEpisodes = widget.episodes
        .where((IEpisode e) => e.season == _selectedSeason)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UIHeaderText(
            'Episodes',
            fontSize: 24,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              _seasons.length,
              (int index) => UILabelCard(
                text: 'Season ${_seasons[index]}',
                backgroundColor: _selectedSeason == _seasons[index]
                    ? AppColors.primary
                    : AppColors.background,
                borderColor: AppColors.primary,
                onPressed: () =>
                    setState(() => _selectedSeason = _seasons[index]),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: AppColors.dark2,
              borderRadius: BorderRadius.circular(
                22,
              ),
              border: Border.all(
                width: 1.5,
                color: AppColors.border,
              ),
            ),
            child: Column(
              children: List.generate(
                selectedEpisodes.length,
                (index) => _buildEpisode(
                  episode: selectedEpisodes[index],
                  index: index,
                  isLastIndex: index == (selectedEpisodes.length - 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisode({
    required IEpisode episode,
    required int index,
    required bool isLastIndex,
  }) {
    return UICoreButton(
      onPressed: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.dark1,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: UINetworkImage(
                    height: 72,
                    width: 80,
                    url: episode.featuredImageUrl,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIText(
                        'Episode ${index + 1}',
                        color: AppColors.text,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 6),
                      UIText(
                        episode.name,
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const SizedBox(height: 16),
          if (!isLastIndex) const UIDivider(),
        ],
      ),
    );
  }
}