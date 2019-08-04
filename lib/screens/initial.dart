import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welearn/components/oninit.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/hometabs/tab1.dart';
import 'package:welearn/screens/hometabs/tab2.dart';
import 'package:welearn/screens/hometabs/tab3.dart';
import 'package:welearn/screens/qr_scan.dart';
import 'package:welearn/styles/styles.dart';


class RootPage extends StatefulWidget {

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final int totallecciones = 0;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    Widget _body() {
      switch (mainProvider.page) {
        case 0:
          {
            return Tab1(
              uid: mainProvider.currentUser.uid,
            );
          }

        case 1:
          {
            return Tab2();
          }
        case 2:
          {
            return Tab3();
          }
        default:
          return Container(
            child: Text('Not Found'),
          );
      }
    }

    return StatefulWrapper(
      onInit: () {},
      child: Scaffold(
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

          ),
          body: _body(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primary,
            child: Icon(Icons.camera_alt),
            onPressed: () {
              final page = QRViewExample();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>page));

            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: BubbleBottomBar(
            opacity: .2,
            hasNotch: true,
            hasInk: true, fabLocation: BubbleBottomBarFabLocation.end,
            currentIndex: mainProvider.page,
            onTap: (index) {
              mainProvider.page = index;
              mainProvider.page == 1
                  ? mainProvider.pageName = "USUARIO"
                  : mainProvider.page == 2
                      ? mainProvider.pageName = "NOTICIAS"
                      : mainProvider.pageName = "INICIO";
            },
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            elevation: 8, //new
            inkColor:
                Colors.black12, //optional, uses theme color if not specified
            items: <BubbleBottomBarItem>[
              BubbleBottomBarItem(
                  backgroundColor: Colors.red,
                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.home,
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
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.notifications,
                    color: Colors.indigo,
                  ),
                  title: Text("Noticias")),
            ],
          )),
    );
  }
}
