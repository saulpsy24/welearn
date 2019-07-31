import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/hometabs/tab1.dart';
import 'package:welearn/screens/hometabs/tab2.dart';
import 'package:welearn/screens/hometabs/tab3.dart';
import 'package:welearn/screens/live_class.dart';

class RootPage extends StatelessWidget {
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
            return LiveStreamClass();
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
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(FontAwesomeIcons.search),
            )
          ],
        ),
        body: _body(),
        bottomNavigationBar: BubbleBottomBar(
          opacity: .2,
          currentIndex: mainProvider.page,
          onTap: (index) {
            mainProvider.page = index;
            mainProvider.page == 1
                ? mainProvider.pageName = "USUARIO"
                : mainProvider.page == 2
                    ? mainProvider.pageName = "MENSAJES"
                    : mainProvider.pageName = "INICIO";
          },
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          elevation: 8, //new
          hasNotch: true, //new
          hasInk: true, //new, gives a cute ink effect
          inkColor:
              Colors.black12, //optional, uses theme color if not specified
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
                backgroundColor: Colors.red,
                icon: Icon(
                  Icons.dashboard,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.dashboard,
                  color: Colors.red,
                ),
                title: Text("Inicio")),
            BubbleBottomBarItem(
                backgroundColor: Colors.deepPurple,
                icon: Icon(
                  Icons.people,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.people,
                  color: Colors.deepPurple,
                ),
                title: Text("Mi Cuenta")),
            BubbleBottomBarItem(
                backgroundColor: Colors.indigo,
                icon: Icon(
                  Icons.folder_open,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.folder_open,
                  color: Colors.indigo,
                ),
                title: Text("Archivo")),
          ],
        ));
  }
}
