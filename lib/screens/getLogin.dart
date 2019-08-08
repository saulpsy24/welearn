import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/initial.dart';
import 'package:welearn/screens/login.dart';

class GetLogin extends StatefulWidget {
  GetLogin({Key key}) : super(key: key);

  _GetLoginState createState() => _GetLoginState();
}

class _GetLoginState extends State<GetLogin> {
  FirebaseUser usuario;

  void _isLogin() async {
    var mainProvider = Provider.of<MainProvider>(context);

    FirebaseAuth.instance.currentUser().then((user) {
      mainProvider.currentUser=user;
     
    });
  }

  @override
  void initState() {
    super.initState();

SchedulerBinding.instance.addPostFrameCallback((_) => _isLogin());
  }

  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<MainProvider>(context);
    switch (mainProvider.currentUser) {
      case null:
        {
          return LoginPage();
        }
      default:
        {
          return RootPage();
        }
    }

  }
}
