import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';

import 'getLogin.dart';

class SplashScreenO extends StatelessWidget {
  final Widget page = GetLogin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen.navigate(
        name: 'assets/splash.flr',
        next: page,
        until: () {
          return Future.delayed(Duration(milliseconds: 1));
        },
        startAnimation: 'splash',
      ),
    );
  }
}
