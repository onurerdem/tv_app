import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/helpers/asset_svgs_helper.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/cards/label_card_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/header_text_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';
import 'package:tv_app/features/tv_shows/presentation/widgets/tv_show_episodes_widget.dart';

class TvShowContent extends StatelessWidget {
  const TvShowContent({
    required this.tvShow,
    super.key,
  });

  final ITvShow tvShow;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        _buildDescription(),
        if (tvShow.tvShowSchedule != null || tvShow.network != null) ...[
          const SizedBox(height: 40),
          _buildWatchAt(),
        ],
        if (tvShow.episodes.isNotEmpty) ...[
          const SizedBox(height: 40),
          TvShowEpsisodes(
            episodes: tvShow.episodes,
          ),
        ],
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.dark1,
        image: DecorationImage(
          image: NetworkImage(
            tvShow.featuredImageUrl,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.black.withOpacity(.35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 240),
            UIText(
              tvShow.name,
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
              shadows: <Shadow>[
                Shadow(
                  offset: const Offset(1, 1),
                  blurRadius: 1.0,
                  color: AppColors.black.withOpacity(.8),
                ),
              ],
            ),
            UIText(
              '${tvShow.premieredAt?.year}${tvShow.premieredAt != null && tvShow.endedAt != null ? ' | ' : ''}${tvShow.endedAt?.year}',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
              shadows: <Shadow>[
                Shadow(
                  offset: const Offset(1, 1),
                  blurRadius: 1.0,
                  color: AppColors.black.withOpacity(.9),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tvShow.description != null) ...[
              const UIHeaderText(
                'Description',
                fontSize: 24,
              ),
              const SizedBox(height: 8),
              UIText(
                tvShow.description!,
                fontSize: 16,
                color: AppColors.text,
              ),
              const SizedBox(height: 12),
            ],
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                tvShow.genres.toList().length,
                (int index) => UILabelCard(
                  backgroundColor: AppColors.black,
                  text: tvShow.genres[index],
                  verticalPadding: 4,
                  horizontalPadding: 10,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildWatchAt() => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UIHeaderText(
              'Watch At',
              fontSize: 24,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (tvShow.network != null)
                  UILabelCard(
                    text: tvShow.network!,
                    verticalPadding: 4,
                    horizontalPadding: 10,
                    backgroundColor: Colors.lightBlue,
                  ),
                if (tvShow.tvShowSchedule?.days?.isNotEmpty ?? false)
                  UILabelCard(
                    text: tvShow.tvShowSchedule!.days!.join(', '),
                    verticalPadding: 4,
                    horizontalPadding: 10,
                    svgIconPath: AssetSvgsHelper.calendar,
                    backgroundColor: Colors.lightBlue,
                  ),
                if (tvShow.tvShowSchedule?.time != null)
                  UILabelCard(
                    text: tvShow.tvShowSchedule!.time!,
                    verticalPadding: 4,
                    horizontalPadding: 10,
                    svgIconPath: AssetSvgsHelper.clock,
                    backgroundColor: Colors.lightBlue,
                  ),
              ],
            ),
          ],
        ),
      );
}