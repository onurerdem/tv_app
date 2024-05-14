import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/buttons/icon_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/cards/label_card_widget.dart';
import 'package:tv_app/core/design_system/widgets/images/network_image_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/divider_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';
import 'package:tv_app/features/tv_shows/domain/interfaces/tv_show_interface.dart';

class TvShowCard extends StatelessWidget {
  const TvShowCard({
    required this.onPressed,
    required this.tvShow,
    this.iconButton,
    super.key,
  });

  final VoidCallback onPressed;
  final ITvShow tvShow;
  final UIIconButton? iconButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14),
        UICoreButton(
          onPressed: onPressed,
          child: Row(
            children: [
              Container(
                height: 140,
                width: 90,
                decoration: BoxDecoration(
                  color: AppColors.dark1,
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.hardEdge,
                child: UINetworkImage(
                  url: tvShow.featuredImageUrl,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UIText(
                                tvShow.name,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                              UIText(
                                tvShow.summary,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                                maxLines: 4,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        if (iconButton != null) ...[
                          const SizedBox(width: 6),
                          iconButton!,
                        ],
                      ],
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: List.generate(
                        tvShow.genres.take(3).toList().length,
                        (int index) => UILabelCard(
                          backgroundColor: AppColors.black,
                          text: tvShow.genres[index],
                          fontSize: 10,
                          verticalPadding: 4,
                          horizontalPadding: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const UIDivider(
          height: 0,
        ),
      ],
    );
  }
}