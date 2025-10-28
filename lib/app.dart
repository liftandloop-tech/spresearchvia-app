import 'package:flutter/material.dart';

import 'screens/splash/splash.screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "spresearchvia",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.white),
      ),
      home: SplashScreen(),
    );
  }
}
