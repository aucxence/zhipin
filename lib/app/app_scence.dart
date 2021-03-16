import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/app/splash_screen.dart';

import 'package:fluro/fluro.dart' as fluro;
import 'package:my_zhipin_boss/routers/routers.dart';
import 'package:my_zhipin_boss/routers/application.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScene extends StatelessWidget {
  AppScene() {
    final router = fluro.Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(builder: (context, child, model) {
      return MaterialApp(
        title: 'Zhipin boss',
        debugShowCheckedModeBanner: false,
        theme: model.theme,
        home: SplashScreen(),
        //home: JobList(),
        onGenerateRoute: Application.router.generator,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
      );
    });
  }
}
