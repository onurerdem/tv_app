import 'package:flutter/widgets.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/images/network_image_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';
import 'package:tv_app/core/helpers/date_helper.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/episode_interface.dart';

class EpisodeBottomSheetContent extends StatelessWidget {
  const EpisodeBottomSheetContent({
    required this.episode,
    required this.index,
    super.key,
  });

  final int index;
  final IEpisode episode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 110,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.dark1,
                borderRadius: BorderRadius.circular(6),
              ),
              clipBehavior: Clip.hardEdge,
              child: UINetworkImage(
                height: 110,
                width: 120,
                url: episode.featuredImageUrl,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UIText(
                    'Season ${episode.season} | Episode ${index + 1}',
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(height: 6),
                  UIText(
                    episode.name,
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  if (episode.airdate != null) ...[
                    const SizedBox(height: 6),
                    UIText(
                      DateHelper.smartDate(date: episode.airdate!),
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        UIText(
          episode.description ?? '',
          color: AppColors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}