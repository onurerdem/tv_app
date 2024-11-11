import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:tv_app/core/utils/constants.dart';
import 'package:tv_app/features/series/data/datasources/remote/series_remote_data_source_impl.dart';
import 'package:tv_app/features/series/domain/usecases/get_all_series.dart';
import 'features/series/data/datasources/series_remote_data_source.dart';
import 'features/series/data/repositories/series_repository_impl.dart';
import 'features/series/domain/repositories/series_repository.dart';
import 'features/series/domain/usecases/search_series.dart';
import 'core/network/api_client.dart';
import 'features/series/presentation/bloc/series_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = BASE_URL;
    return dio;
  });

  sl.registerLazySingleton(() => ApiClient(sl<Dio>()));

  sl.registerLazySingleton<SeriesRemoteDataSource>(
          () => SeriesRemoteDataSourceImpl(sl<ApiClient>()));

  sl.registerLazySingleton<SeriesRepository>(
          () => SeriesRepositoryImpl(sl<SeriesRemoteDataSource>()));

  sl.registerLazySingleton(() => SearchSeries(sl<SeriesRepository>()));

  sl.registerLazySingleton(() => GetAllSeries(sl<SeriesRepository>()));

  sl.registerFactory(() => SeriesBloc(sl<SearchSeries>(), sl<GetAllSeries>()));
}