import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import 'package:tv_app/features/series/presentation/bloc/series_event.dart';
import 'package:tv_app/features/series/presentation/bloc/series_state.dart';
import '../../domain/usecases/get_all_series.dart';
import '../../domain/usecases/search_series.dart';

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final SearchSeries searchSeries;
  final GetAllSeries getAllSeries;

  SeriesBloc(this.searchSeries, this.getAllSeries) : super(SeriesInitial()) {
    on<GetAllSeriesEvent>((event, emit) async {
      emit(SeriesLoading());
      final result = await getAllSeries(NoParams());
      result.fold(
        (failure) => emit(SeriesError("Failed to load series.")),
        (series) => emit(SeriesLoaded(series)),
      );
    });

    on<SearchSeriesQuery>((event, emit) async {
      emit(SeriesLoading());
      if (event.query.isEmpty) {
        add(GetAllSeriesEvent());
      } else {
        final result = await searchSeries(event.query);
        result.fold(
          (failure) => emit(SeriesError("Failed to load search results.")),
          (series) => emit(SeriesLoaded(series)),
        );
      }
    });
  }
}
