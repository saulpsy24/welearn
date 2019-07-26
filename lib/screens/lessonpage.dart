import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LessonPage extends StatefulWidget {
  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  String webContent =
      '<h1 style="text-align: center;">Titulo de la lección</h1><p style="text-align: center;"><strong>Lorem Ipsum</strong><span> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum</span></p>';
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.initialize();
          _controller.play();
        });
      });
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
    );
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
      body: Column(
        children: <Widget>[
          Center(
              child: Container(
            color: Colors.black,
            child: Chewie(
              controller: _chewieController,
            ),
          )),
          Container(
            height: MediaQuery.of(context).size.height*.5,
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
