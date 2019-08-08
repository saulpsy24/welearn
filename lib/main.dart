import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/getLogin.dart';
import 'package:welearn/screens/login.dart';
import 'package:welearn/screens/splash.dart';

void main() {
   
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return ChangeNotifierProvider(
      builder: (context) => MainProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: SplashScreenO(),
      ),
    );
  }
}
