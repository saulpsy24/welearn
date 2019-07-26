import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/hometabs/tab1.dart';
import 'package:welearn/screens/hometabs/tab2.dart';
import 'package:welearn/screens/hometabs/tab3.dart';

class RootPage extends StatelessWidget {
  final GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    Widget _body() {
      switch (mainProvider.page) {
        case 0:
          {
            return Tab1();
          }

        case 1:
          {
            return Tab2();
          }
        case 2:
          {
            return VideoApp();
          }
        default:
          return Container(
            child: Text('Not Found'),
          );
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        title: Text(
          mainProvider.pageName,
          style: TextStyle(
              color: Colors.black87, fontFamily: 'hero', fontSize: 17),
        ),
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.black38),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.search),
          )
        ],
      ),
      body: _body(),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        color: Colors.grey[400],
        backgroundColor: Colors.transparent,
        items: <Widget>[
          Icon(
            CupertinoIcons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            CupertinoIcons.profile_circled,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            CupertinoIcons.mail,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          mainProvider.page = index;
          mainProvider.page == 1
              ? mainProvider.pageName = "USUARIO"
              : mainProvider.page == 2
                  ? mainProvider.pageName = "MENSAJES"
                  : mainProvider.pageName = "INICIO";
        },
      ),
    );
  }
}
