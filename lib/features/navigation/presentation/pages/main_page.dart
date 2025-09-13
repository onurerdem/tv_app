import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../main.dart';
import '../../../actors/presentation/bloc/actors_bloc.dart';
import '../../../actors/presentation/pages/actors_page.dart';
import '../../../authentication/presentation/bloc/profile_bloc.dart';
import '../../../authentication/presentation/cubit/authentication/authentication_cubit.dart';
import '../../../authentication/presentation/pages/profile_page.dart';
import '../../../series/presentation/bloc/series_bloc.dart';
import '../../../series/presentation/pages/series_page.dart';
import '../../../watched/presentation/bloc/watched_bloc.dart';
import '../bloc/navigation_bloc.dart';
import 'package:tv_app/features/series/presentation/widgets/show_exit_dialog.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationCubit>().state;
    String? uId;
    if (authState is Authenticated) {
      uId = FirebaseAuth.instance.currentUser?.uid;

      if (kDebugMode) {
        print(
            'UId: $uId *********************************************************************************');
      }
    }

    if (kDebugMode) {
      print(
          'UId2: $uId *********************************************************************************');
    }

    if (uId == null) {
      if (kDebugMode) {
        print(
            'UId3: $uId *********************************************************************************');
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil('/signIn', (route) => false);

        if (kDebugMode) {
          print(
              '/signIn *********************************************************************************');
        }
      });
    }

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, navState) {
        Widget currentPage;
        switch (navState.selectedIndex) {
          case 0:
            currentPage = MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<SeriesBloc>()),
                BlocProvider.value(value: context.read<WatchedBloc>()),
              ],
              child: SeriesPage(uid: uId!),
            );
            break;

          case 1:
            currentPage = BlocProvider.value(
              value: context.read<ActorsBloc>(),
              child: const ActorsPage(),
            );
            break;

          case 2:
            currentPage = BlocProvider.value(
              value: context.read<ProfileBloc>(),
              child: const ProfilePage(),
            );
            break;

          default:
            currentPage = const SizedBox.shrink();
        }

        return PopScope(
          canPop: navState.history.isEmpty,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) {
              context.read<NavigationBloc>().add(GoBackEvent());
              if (navState.history.length <= 1) showExitDialog(context);
            }
          },
          child: Scaffold(
            body: currentPage,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: navState.selectedIndex,
              onTap: (i) =>
                  context.read<NavigationBloc>().add(ChangeTabEvent(i)),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Series'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.people), label: 'Actors'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
        );
      },
    );
  }
}
