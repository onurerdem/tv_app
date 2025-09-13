import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tv_app/features/authentication/presentation/cubit/authentication/authentication_cubit.dart';
import 'package:tv_app/features/favoriteActors/presentation/bloc/favorite_actors_event.dart';
import 'package:tv_app/features/series/presentation/pages/splash_screen.dart';
import 'package:tv_app/features/watched/presentation/bloc/watched_event.dart';
import 'features/actors/domain/usecases/get_actor_cast_credits_usecase.dart';
import 'features/actors/domain/usecases/get_actor_details_usecase.dart';
import 'features/actors/presentation/bloc/actor_details_bloc.dart';
import 'features/actors/presentation/bloc/actors_bloc.dart';
import 'features/authentication/presentation/bloc/profile_bloc.dart';
import 'features/authentication/presentation/cubit/user/user_cubit.dart';
import 'features/authentication/presentation/pages/sign_in_page.dart';
import 'features/authentication/presentation/pages/verify_email_page.dart';
import 'features/favoriteActors/presentation/bloc/favorite_actors_bloc.dart';
import 'features/navigation/presentation/bloc/navigation_bloc.dart';
import 'features/navigation/presentation/pages/main_page.dart';
import 'features/serie_favorites/presentation/bloc/serie_favorites_bloc.dart';
import 'features/series/domain/usecases/get_episodes.dart';
import 'features/series/domain/usecases/get_serie_details.dart';
import 'features/series/presentation/bloc/serie_details_bloc.dart';
import 'features/series/presentation/bloc/series_bloc.dart';
import 'features/series/presentation/bloc/series_event.dart';
import 'features/series/presentation/pages/onboarding_screen.dart';
import 'features/watched/presentation/bloc/watched_bloc.dart';
import 'features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'features/watchlist/presentation/bloc/watchlist_event.dart';
import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<SeriesBloc>()
            ..add(
              FetchSeriesEvent(),
            ),
        ),
        BlocProvider<WatchedBloc>(
          create: (_) => di.sl<WatchedBloc>()
            ..add(
              LoadWatchedSeries(),
            ),
        ),
        BlocProvider(
          create: (_) => SerieDetailsBloc(
            di.sl<GetSerieDetails>(),
            di.sl<GetEpisodes>(),
          ),
        ),
        BlocProvider<NavigationBloc>(
          create: (_) => di.sl<NavigationBloc>(),
        ),
        BlocProvider<AuthenticationCubit>(
          create: (_) => di.sl<AuthenticationCubit>()..appStarted(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => di.sl<UserCubit>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => di.sl<ProfileBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<ActorsBloc>(),
        ),
        BlocProvider(
          create: (_) => ActorDetailsBloc(
            di.sl<GetActorDetailsUseCase>(),
            di.sl<GetActorCastCreditsUseCase>(),
          ),
        ),
        BlocProvider<SerieFavoritesBloc>(
          create: (_) => di.sl<SerieFavoritesBloc>()
            ..add(
              LoadSerieFavorites(),
            ),
        ),
        BlocProvider<FavoriteActorsBloc>(
          create: (_) => di.sl<FavoriteActorsBloc>()
            ..add(
              LoadFavoritesEvent(),
            ),
        ),
        BlocProvider<WatchlistBloc>(
          create: (_) => di.sl<WatchlistBloc>()
            ..add(
              LoadWatchlist(),
            ),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Series',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: const BorderSide(
                width: 4.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: const BorderSide(
                width: 4.0,
              ),
            ),
          ),
        ),
        //initialRoute: '/',
        routes: {
          //'/': (_) => const SplashScreen(),
          '/onboard': (_) => const OnboardingScreen(),
          '/signIn': (_) => const SignInPage(),
          '/verifyEmail': (_) => VerifyEmailPage(),
          '/main': (_) => const MainPage(),
        },

        builder: (ctx, child) {
          return BlocListener<AuthenticationCubit, AuthenticationState>(
            listenWhen: (prev, curr) =>
            curr is Authenticated || curr is UnAuthenticated,
            listener: (ctx, state) {
              if (state is Authenticated) {
                navigatorKey.currentState!
                    .pushNamedAndRemoveUntil('/main', (_) => false);
              } else {
                navigatorKey.currentState!
                    .pushNamedAndRemoveUntil('/signIn', (_) => false);
              }
            },
            child: child,
          );
        },

        home: const SplashScreen(),
      ),
    );
  }
}
