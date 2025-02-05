import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/features/series/presentation/pages/splash_screen.dart';
import 'features/series/domain/usecases/get_serie_details.dart';
import 'features/series/presentation/bloc/serie_details_bloc.dart';
import 'features/series/presentation/bloc/series_bloc.dart';
import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            create: (_) => di.sl<SeriesBloc>(),
          ),
          BlocProvider(
            create: (_) => SerieDetailsBloc(di.sl<GetSerieDetails>()),
          ),
        ],
        child: MaterialApp(
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
            home: const SplashScreen(),
        ),
    );
  }
}
