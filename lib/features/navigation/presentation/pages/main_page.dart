import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tv_app/features/authentication/presentation/bloc/profile_bloc.dart';
import 'package:tv_app/features/authentication/presentation/pages/profile_page.dart';
import 'package:tv_app/features/series/presentation/pages/series_page.dart';
import 'package:tv_app/features/navigation/presentation/bloc/navigation_bloc.dart';

import '../../../series/presentation/bloc/series_bloc.dart';
import '../../../series/presentation/widgets/show_exit_dialog.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      BlocProvider.value(
        value: BlocProvider.of<SeriesBloc>(context),
        child: SeriesPage(uid: firebaseUser!.uid),
      ),
      Container(color: Colors.green),
      BlocProvider.value(
        value: BlocProvider.of<ProfileBloc>(context),
        child: const ProfilePage(),
      ),
    ];

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return PopScope(
          canPop: state.history.length <= 1,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              context.read<NavigationBloc>().add(GoBackEvent());
              if (state.history.length <= 1) {
                showExitDialog(context);
              }
            }
          },
          child: Scaffold(
            body: _pages[state.selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.selectedIndex,
              onTap: (index) {
                context.read<NavigationBloc>().add(ChangeTabEvent(index));
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.tv),
                  label: 'Series',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Actors',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
