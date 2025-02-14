import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:tv_app/core/utils/constants.dart';
import 'package:tv_app/features/series/data/datasources/remote/series_remote_data_source_impl.dart';
import 'package:tv_app/features/series/domain/usecases/get_all_series.dart';
import 'package:tv_app/features/series/domain/usecases/get_serie_details.dart';
import 'package:tv_app/features/series/presentation/bloc/serie_details_bloc.dart';
import 'features/authentication/data/datasources/firebase_remote_data_source.dart';
import 'features/authentication/data/datasources/remote/firebase_remote_data_source_impl.dart';
import 'features/authentication/data/repositories/firebase_repository_impl.dart';
import 'features/authentication/domain/repositories/firebase_repository.dart';
import 'features/authentication/domain/usacases/get_create_current_user_usecase.dart';
import 'features/authentication/domain/usacases/get_current_uid_usecase.dart';
import 'features/authentication/domain/usacases/is_sign_in_usecase.dart';
import 'features/authentication/domain/usacases/sign_in_usecase.dart';
import 'features/authentication/domain/usacases/sign_out_usecase.dart';
import 'features/authentication/domain/usacases/sign_up_usecase.dart';
import 'features/authentication/presentation/cubit/authentication/authentication_cubit.dart';
import 'features/authentication/presentation/cubit/user/user_cubit.dart';
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

  sl.registerLazySingleton(() => GetSerieDetails(sl<SeriesRepository>()));

  sl.registerFactory(() => SeriesBloc(sl<SearchSeries>(), sl<GetAllSeries>()));

  sl.registerFactory(() => SerieDetailsBloc(sl<GetSerieDetails>()));

  sl.registerFactory<AuthenticationCubit>(() => AuthenticationCubit(
      isSignInUseCase: sl.call(),
      signOutUseCase: sl.call(),
      getCurrentUidUseCase: sl.call()));
  sl.registerFactory<UserCubit>(() => UserCubit(
    getCreateCurrentUserUseCase: sl.call(),
    signInUseCase: sl.call(),
    signUPUseCase: sl.call(),
  ));

  sl.registerLazySingleton<GetCreateCurrentUserUsecase>(
          () => GetCreateCurrentUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUidUseCase>(
          () => GetCurrentUidUseCase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUseCase>(
          () => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignInUseCase>(
          () => SignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(
          () => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignUPUseCase>(
          () => SignUPUseCase(repository: sl.call()));

  sl.registerLazySingleton<FirebaseRepository>(
          () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(auth: sl.call(), firestore: sl.call()));

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
}