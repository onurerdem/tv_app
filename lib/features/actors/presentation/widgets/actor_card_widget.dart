import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/buttons/icon_button_widget.dart';
import 'package:tv_app/core/design_system/widgets/cards/label_card_widget.dart';
import 'package:tv_app/core/design_system/widgets/images/network_image_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/divider_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/text_widget.dart';
import 'package:tv_app/core/helpers/date_helper.dart';
import 'package:tv_app/features/actors/domain/actor_interface.dart';

class ActorCard extends StatelessWidget {
  const ActorCard({
    required this.onPressed,
    required this.actor,
    this.iconButton,
    super.key,
  });

  final VoidCallback onPressed;
  final IActor actor;
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
                height: 60,
                width: 55,
                decoration: BoxDecoration(
                  color: AppColors.dark1,
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.hardEdge,
                child: UINetworkImage(
                  url: actor.imageUrl,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIText(
                      actor.name,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                    if (actor.country != null || actor.birthday != null) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (actor.country != null)
                            UILabelCard(
                              backgroundColor: AppColors.black,
                              text: actor.country!,
                              fontSize: 10,
                              verticalPadding: 4,
                              horizontalPadding: 8,
                            ),
                          if (actor.birthday != null)
                            UILabelCard(
                              backgroundColor: AppColors.black,
                              text:
                                  '${DateHelper.calculateAge(actor.birthday!)} Years',
                              fontSize: 10,
                              verticalPadding: 4,
                              horizontalPadding: 8,
                            ),
                        ],
                      ),
                    ],
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