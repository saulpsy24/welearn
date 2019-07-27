import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:flutube/flutube.dart';

class LessonPage extends StatefulWidget {
  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  int currentPos;

  String webContent =
      '<h1 style="text-align: center;">Titulo de la lección</h1><p style="text-align: center;"><strong>Lorem Ipsum</strong><span> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum</span></p>';
  @override
  void initState() {
    currentPos = 0;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'LECCION',
          style: TextStyle(color: Colors.black, fontFamily: 'hero'),
        ),
      ),
      body: SafeArea(
              child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                
                color: Colors.black,
                child: FluTube(
                  "https://youtu.be/al4DSgjB3oU",
                  autoInitialize: true,
                  aspectRatio: 16 / 9,
                  allowMuting: false,
                  autoPlay: true,
                  allowFullScreen: true,
                  fullscreenByDefault: false,
                  deviceOrientationAfterFullscreen: [
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.portraitUp
                  ],
                  onVideoStart: () {},
                  systemOverlaysAfterFullscreen: SystemUiOverlay.values,
                  onVideoEnd: () {
                    print("aqui");
                    setState(() {
                      currentPos++;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .5,
              child: ListView(
                children: <Widget>[
                  HtmlWidget(
                    webContent,
                    webView: true,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
