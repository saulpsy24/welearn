import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        usuario = user;
      });
    });
  }

  @override
  void initState() {
    _isLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<MainProvider>(context);
    switch (usuario) {
      case null:
        {
          return LoginPage();
        }
      default:
        {
          mainProvider.currentUser=usuario;
          return RootPage();
        }
    }
  }
}
