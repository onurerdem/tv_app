import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/core/usecase/usecase.dart';
import 'package:tv_app/features/series/presentation/bloc/series_event.dart';
import 'package:tv_app/features/series/presentation/bloc/series_state.dart';
import '../../domain/entities/series.dart';
import '../../domain/usecases/get_all_series.dart';
import '../../domain/usecases/get_series_by_page.dart';
import '../../domain/usecases/search_series.dart';

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final SearchSeries searchSeries;
  final GetAllSeries getAllSeries;
  final GetSeriesByPage getByPage;

  int _currentPage = 0;

  SeriesBloc(
    this.searchSeries,
    this.getAllSeries,
    this.getByPage,
  ) : super(SeriesLoaded([], false)) {
    on<GetAllSeriesEvent>((event, emit) async {
      emit(SeriesLoading());
      final result = await getAllSeries(NoParams());
      result.fold(
        (failure) => emit(SeriesError("Failed to load series.")),
        (series) => emit(SeriesLoaded(series, series.isEmpty)),
      );
    });

    on<SearchSeriesQuery>((event, emit) async {
      emit(SeriesLoading());
      if (event.query.isEmpty) {
        _currentPage = 0;
        add(FetchSeriesEvent());
      } else {
        final result = await searchSeries(event.query);
        result.fold(
          (failure) => emit(SeriesError("Failed to load search results.")),
          (series) => emit(SeriesLoaded(series, series.isEmpty)),
        );
      }
    });

    on<FetchSeriesEvent>((event, emit) async {
      final currentState = state;
      List<Series> oldSeries = [];
      if (currentState is SeriesLoaded) {
        oldSeries = currentState.seriesList;
        if (currentState.hasReachedMax) return;
      }

      final result = await getByPage(_currentPage);
      result.fold(
        (failure) => emit(SeriesError("Failed to load series.")),
        (newSeries) {
          final allSeries = [...oldSeries, ...newSeries];
          final hasEnd = newSeries.isEmpty;
          if (!hasEnd) _currentPage++;
          emit(SeriesLoaded(allSeries, hasEnd));
        },
      );
    });
  }
}
