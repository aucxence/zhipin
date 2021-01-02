import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/app/splash_screen.dart';

import 'package:fluro/fluro.dart';
import 'package:my_zhipin_boss/routers/routers.dart';
import 'package:my_zhipin_boss/routers/application.dart';

class AppScene extends StatelessWidget {
  AppScene() {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          platform: TargetPlatform.android,
          primaryColor: Colors.white,
          dividerColor: Color(0xFFEEEEEE),
          scaffoldBackgroundColor: Colours.bg_color,
          textTheme: TextTheme(body1: TextStyle(color: Colours.bg_gray)),
          fontFamily: 'PingFang'),
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
  }
}
