import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_app/core/dependencies/dependencies.dart';
import 'package:tv_app/core/design_system/theme/theme.dart';

class TvApp extends StatelessWidget {
  const TvApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: getIt<GoRouter>(),
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      builder: ((
        BuildContext context,
        Widget? child,
      ) =>
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: child,
          )),
    );
  }
}