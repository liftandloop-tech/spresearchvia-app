import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spresearchvia2/core/theme/app_theme.dart';
import 'screens/splash/splash.screen.dart';
import 'screens/auth/login.screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "spresearchvia",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppTheme.backgroundWhite,
        appBarTheme: AppBarTheme(color: AppTheme.backgroundWhite),
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
      ],
      home: SplashScreen(),
    );
  }
}
