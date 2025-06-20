import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:tv_app/core/utils/constants.dart';
import 'package:tv_app/features/authentication/domain/usacases/get_user_profile_usecase.dart';
import 'package:tv_app/features/series/data/datasources/remote/series_remote_data_source_impl.dart';
import 'package:tv_app/features/series/domain/usecases/get_all_series.dart';
import 'package:tv_app/features/series/domain/usecases/get_serie_details.dart';
import 'package:tv_app/features/series/presentation/bloc/serie_details_bloc.dart';
import 'features/actors/data/datasources/actors_remote_data_source.dart';
import 'features/actors/data/datasources/remote/actors_remote_data_source_impl.dart';
import 'features/actors/data/repositories/actors_repository_impl.dart';
import 'features/actors/domain/repositories/actors_repository.dart';
import 'features/actors/domain/usecases/get_actor_cast_credits_usecase.dart';
import 'features/actors/domain/usecases/get_actor_details_usecase.dart';
import 'features/actors/domain/usecases/get_actors_by_page.dart';
import 'features/actors/domain/usecases/get_all_actors.dart';
import 'features/actors/domain/usecases/search_actors.dart';
import 'features/actors/presentation/bloc/actor_details_bloc.dart';
import 'features/actors/presentation/bloc/actors_bloc.dart';
import 'features/authentication/data/datasources/firebase_remote_data_source.dart';
import 'features/authentication/data/datasources/remote/firebase_remote_data_source_impl.dart';
import 'features/authentication/data/repositories/firebase_repository_impl.dart';
import 'features/authentication/domain/repositories/firebase_repository.dart';
import 'features/authentication/domain/usacases/change_password_use_case.dart';
import 'features/authentication/domain/usacases/forgot_password_usecase.dart';
import 'features/authentication/domain/usacases/get_create_current_user_usecase.dart';
import 'features/authentication/domain/usacases/get_current_uid_usecase.dart';
import 'features/authentication/domain/usacases/is_sign_in_usecase.dart';
import 'features/authentication/domain/usacases/sign_in_usecase.dart';
import 'features/authentication/domain/usacases/sign_out_usecase.dart';
import 'features/authentication/domain/usacases/sign_up_usecase.dart';
import 'features/authentication/domain/usacases/update_user_profile_usecase.dart';
import 'features/authentication/presentation/bloc/profile_bloc.dart';
import 'features/authentication/presentation/cubit/authentication/authentication_cubit.dart';
import 'features/authentication/presentation/cubit/user/user_cubit.dart';
import 'features/favoriteActors/data/datasources/remote/favorite_actors_remote_data_source_impl.dart';
import 'features/favoriteActors/data/repositories/favorite_actors_repository_impl.dart';
import 'features/favoriteActors/domain/repositories/favorite_actors_repository.dart';
import 'features/favoriteActors/domain/usecases/add_actor_to_favorites.dart';
import 'features/favoriteActors/domain/usecases/get_favorite_actors.dart';
import 'features/favoriteActors/domain/usecases/remove_actor_from_favorites.dart';
import 'features/favoriteActors/presentation/bloc/favorite_actors_bloc.dart';
import 'features/favoriteActors/presentation/bloc/favorite_actors_event.dart';
import 'features/navigation/presentation/bloc/navigation_bloc.dart';
import 'features/serie_favorites/data/datasources/remote/serie_favorites_remote_datasource_impl.dart';
import 'features/serie_favorites/data/datasources/serie_favorites_remote_datasource.dart';
import 'features/serie_favorites/data/repositories/serie_favorites_repository_impl.dart';
import 'features/serie_favorites/domain/repositories/serie_favorites_repository.dart';
import 'features/serie_favorites/domain/usecases/add_favorite.dart';
import 'features/serie_favorites/domain/usecases/fetch_favorite_series_details.dart';
import 'features/serie_favorites/domain/usecases/get_favorite_series.dart';
import 'features/serie_favorites/domain/usecases/get_favorites.dart';
import 'features/serie_favorites/domain/usecases/remove_favorite.dart';
import 'features/serie_favorites/presentation/bloc/serie_favorites_bloc.dart';
import 'features/series/data/datasources/series_remote_data_source.dart';
import 'features/series/data/repositories/series_repository_impl.dart';
import 'features/series/domain/repositories/series_repository.dart';
import 'features/series/domain/usecases/get_episodes.dart';
import 'features/series/domain/usecases/get_series_by_page.dart';
import 'features/series/domain/usecases/search_series.dart';
import 'core/network/api_client.dart';
import 'features/series/presentation/bloc/series_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(
    () {
      final dio = Dio();
      dio.options.baseUrl = BASE_URL;
      return dio;
    },
  );

  sl.registerLazySingleton(() => ApiClient(sl<Dio>()));

  sl.registerLazySingleton<SeriesRemoteDataSource>(
    () => SeriesRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<SeriesRepository>(
    () => SeriesRepositoryImpl(sl<SeriesRemoteDataSource>()),
  );

  sl.registerLazySingleton(
    () => SearchSeries(sl<SeriesRepository>()),
  );

  sl.registerLazySingleton(
    () => GetAllSeries(sl<SeriesRepository>()),
  );

  sl.registerLazySingleton(
    () => GetSerieDetails(sl<SeriesRepository>()),
  );

  sl.registerLazySingleton(() => GetEpisodes(sl<SeriesRepository>()));

  sl.registerLazySingleton(() => GetSeriesByPage(sl<SeriesRepository>()));

  sl.registerFactory(
    () => SeriesBloc(
      sl<SearchSeries>(),
      sl<GetAllSeries>(),
      sl<GetSeriesByPage>(),
    ),
  );

  sl.registerFactory(
    () => SerieDetailsBloc(
      sl<GetSerieDetails>(),
      sl<GetEpisodes>(),
    ),
  );

  sl.registerFactory<AuthenticationCubit>(
    () => AuthenticationCubit(
      isSignInUseCase: sl.call(),
      signOutUseCase: sl.call(),
      getCurrentUidUseCase: sl.call(),
    ),
  );
  sl.registerFactory<UserCubit>(
    () => UserCubit(
      getCreateCurrentUserUseCase: sl.call(),
      signInUseCase: sl.call(),
      signUpUseCase: sl.call(),
      forgotPasswordUseCase: sl.call(),
    ),
  );

  sl.registerLazySingleton<GetCreateCurrentUserUsecase>(
    () => GetCreateCurrentUserUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<GetCurrentUidUseCase>(
    () => GetCurrentUidUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton<IsSignInUseCase>(
    () => IsSignInUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(remoteDataSource: sl.call()),
  );

  sl.registerLazySingleton<FirebaseRemoteDataSource>(
    () => FirebaseRemoteDataSourceImpl(auth: sl.call(), firestore: sl.call()),
  );

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  sl.registerLazySingleton<FirebaseAuth>(() => auth);
  sl.registerLazySingleton<FirebaseFirestore>(() => fireStore);

  sl.registerFactory(() => NavigationBloc());

  sl.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<UpdateUserProfileUseCase>(
    () => UpdateUserProfileUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(repository: sl.call()),
  );

  sl.registerFactory(
    () => ProfileBloc(
      sl<GetUserProfileUseCase>(),
      sl<UpdateUserProfileUseCase>(),
      sl<ChangePasswordUseCase>(),
    ),
  );

  sl.registerLazySingleton<ActorsRemoteDataSource>(
    () => ActorsRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<ActorsRepository>(
    () => ActorsRepositoryImpl(sl<ActorsRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => GetAllActors(sl<ActorsRepository>()));
  sl.registerLazySingleton(() => SearchActors(sl<ActorsRepository>()));
  sl.registerLazySingleton(() => GetActorsByPage(sl<ActorsRepository>()));

  sl.registerFactory(
    () => ActorsBloc(
      sl<SearchActors>(),
      sl<GetAllActors>(),
      sl<GetActorsByPage>(),
    ),
  );

  sl.registerLazySingleton(
    () => GetActorDetailsUseCase(sl<ActorsRepository>()),
  );
  sl.registerLazySingleton(
    () => GetActorCastCreditsUseCase(sl<ActorsRepository>()),
  );

  sl.registerFactory(
    () => ActorDetailsBloc(
      sl<GetActorDetailsUseCase>(),
      sl<GetActorCastCreditsUseCase>(),
    ),
  );

  sl.registerLazySingleton<SerieFavoritesRemoteDatasource>(
    () => SerieFavoritesRemoteDatasourceImpl(
      sl<FirebaseAuth>(),
      sl<FirebaseFirestore>(),
      sl<ApiClient>(),
    ),
  );

  sl.registerLazySingleton<SerieFavoritesRepository>(
    () => SerieFavoritesRepositoryImpl(
      sl<SerieFavoritesRemoteDatasource>(),
      sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<FetchFavoriteSeriesDetails>(
    () => FetchFavoriteSeriesDetails(
      sl<SerieFavoritesRepository>(),
    ),
  );

  sl.registerLazySingleton<AddFavorite>(
    () => AddFavorite(
      sl<SerieFavoritesRepository>(),
    ),
  );

  sl.registerLazySingleton<RemoveFavorite>(
    () => RemoveFavorite(
      sl<SerieFavoritesRepository>(),
    ),
  );

  sl.registerLazySingleton<GetFavorites>(
    () => GetFavorites(
      sl<SerieFavoritesRepository>(),
    ),
  );

  sl.registerLazySingleton<GetFavoriteSeries>(
    () => GetFavoriteSeries(
      sl<SerieFavoritesRepository>(),
    ),
  );

  sl.registerFactory<SerieFavoritesBloc>(
    () => SerieFavoritesBloc(
      sl<GetFavorites>(),
      sl<AddFavorite>(),
      sl<RemoveFavorite>(),
      sl<FetchFavoriteSeriesDetails>(),
      sl<GetFavoriteSeries>(),
    )..add(LoadSerieFavorites()),
  );

  sl.registerLazySingleton(
    () => FavoriteActorsRemoteDataSourceImpl(
      sl<FirebaseAuth>(),
      sl<FirebaseFirestore>(),
      sl<ApiClient>(),
    ),
  );

  sl.registerLazySingleton<FavoriteActorsRepository>(
    () => FavoriteActorsRepositoryImpl(
      sl<FavoriteActorsRemoteDataSourceImpl>(),
    ),
  );

  sl.registerLazySingleton(
    () => AddActorToFavorites(sl<FavoriteActorsRepository>()),
  );
  sl.registerLazySingleton(
    () => RemoveActorFromFavorites(sl<FavoriteActorsRepository>()),
  );
  sl.registerLazySingleton(
    () => GetFavoriteActors(sl<FavoriteActorsRepository>()),
  );

  sl.registerFactory(
        () => FavoriteActorsBloc(
      sl<GetFavoriteActors>(),
      sl<GetActorDetailsUseCase>(),
      sl<AddActorToFavorites>(),
      sl<RemoveActorFromFavorites>(),
    )..add(LoadFavoritesEvent()),
  );
}
