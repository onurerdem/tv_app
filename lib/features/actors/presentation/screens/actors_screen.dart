import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/core/design_system/widgets/fields/search_field_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/error_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/loading_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/bottom_app_bar.dart';
import 'package:tv_app/core/design_system/widgets/layouts/main_header_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/main_scaffold_widget.dart';
import 'package:tv_app/core/design_system/widgets/pagination/infinity_scroll_pagination_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/header_text_widget.dart';
import 'package:tv_app/features/actors/presentation/widgets/actor_card_widget.dart';
import 'package:tv_app/features/actors/state/actors/actors_cubit.dart';
import 'package:tv_app/features/actors/state/actors/actors_state.dart';

class ActorsScreen extends StatefulWidget {
  const ActorsScreen({super.key});

  @override
  State<ActorsScreen> createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> {
  String _seachText = '';

  @override
  Widget build(BuildContext context) {
    return UIMainScaffold(
      canPop: false,
      mainHeader: UIMainHeader(
        height: 205,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UIHeaderText(
              'Actors',
              fontSize: 32,
            ),
            const SizedBox(height: 8),
            UISearchField(onSearchChanged: (String text) {
              _seachText = text.trim();
              context.read<ActorsCubit>().getActors(
                    search: _seachText.isEmpty ? null : _seachText,
                  );
            }),
            const SizedBox(height: 12),
          ],
        ),
      ),
      body: BlocBuilder<ActorsCubit, ActorsState>(
        builder: (BuildContext context, ActorsState state) {
          if (state is ActorsLoadedState) {
            return UIInfinityScrollPagination(
              topExtraSpace: 196,
              bottomExtraSpace: 100,
              itemsLenght: state.actors.length,
              itemBuilder: (BuildContext context, int index) => ActorCard(
                onPressed: () {},
                actor: state.actors[index],
              ),
              onFetchMore: context.read<ActorsCubit>().getActorsNextPage,
              hasNextPage: state.hasNextPage,
            );
          }
          if (state is ActorsErrorState) {
            return Padding(
              padding: const EdgeInsets.only(top: 200),
              child: UIErrorIndicator(
                errorText:
                    'Failed to load actors, please check your internet connection.',
                onPressed: () => context.read<ActorsCubit>().getActors(
                      search: _seachText.isEmpty ? null : _seachText,
                    ),
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.only(top: 80),
            child: UILoadingIndicator(),
          );
        },
      ),
      bottomAppBar: const UIBottomAppBar(
        currentTab: TabType.actors,
      ),
    );
  }
}