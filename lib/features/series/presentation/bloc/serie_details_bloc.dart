import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/series/domain/usecases/get_episodes.dart';
import 'package:tv_app/features/series/domain/usecases/get_serie_details.dart';
import 'package:tv_app/features/series/presentation/bloc/serie_details_event.dart';
import 'package:tv_app/features/series/presentation/bloc/serie_details_state.dart';

class SerieDetailsBloc extends Bloc<SerieDetailsEvent, SerieDetailsState> {
  final GetSerieDetails getSerieDetails;
  final GetEpisodes getEpisodes;

  SerieDetailsBloc(this.getSerieDetails, this.getEpisodes)
      : super(SerieDetailsInitial()) {
    on<GetSerieDetailsEvent>(_onGetSerieDetails);
    on<SelectSeasonEvent>(_onSelectSeason);
  }

  Future<void> _onGetSerieDetails(
      GetSerieDetailsEvent event, Emitter<SerieDetailsState> emit) async {
    emit(SerieDetailsLoading());

    final detailResult = await getSerieDetails(event.serieId);
    await detailResult.fold(
      (failure) async {
        emit(SerieDetailsError("Series details could not be loaded."));
      },
      (serie) async {
        final episodesResult = await getEpisodes(event.serieId);
        episodesResult.fold((failure) {
          if (kDebugMode) {
            print("Error fetching episodes in BLoC: $failure");
          }
          emit(SerieDetailsLoaded(serie, []));
        }, (episodes) {
          emit(SerieDetailsLoaded(serie, episodes));
        });
      },
    );
  }

  void _onSelectSeason(
      SelectSeasonEvent event, Emitter<SerieDetailsState> emit) {
    final currentState = state;
    if (currentState is SerieDetailsLoaded) {
      emit(currentState.copyWith(
        selectedSeason: event.season,
        forceSelectedSeasonNull: event.season == null,
      ));
    }
  }
}
