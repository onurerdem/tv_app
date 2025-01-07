import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_serie_details.dart';
import 'serie_details_event.dart';
import 'serie_details_state.dart';

class SerieDetailsBloc extends Bloc<SerieDetailsEvent, SerieDetailsState> {
  final GetSerieDetails getSerieDetails;

  SerieDetailsBloc(this.getSerieDetails) : super(SerieDetailsInitial()) {
    on<GetSerieDetailsEvent>((event, emit) async {
      emit(SerieDetailsLoading());

      final result = await getSerieDetails(event.serieId);
      result.fold(
            (failure) => emit(SerieDetailsError("Failed to load serie details.")),
            (serie) => emit(SerieDetailsLoaded(serie)),
      );
    });
  }
}
