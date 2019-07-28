import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as HTML;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:welearn/screens/fullscreen.dart';

class LessonPage extends StatefulWidget {
  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  int currentPos;
  VideoPlayerController _controller;
  int minutos;
  int segundos;
  int inicial;
  int inicialm = 0;

  String webContent =
      '<h1 style="text-align: center;">Titulo de la lección</h1><p style="text-align: center;"><strong>Lorem Ipsum</strong><span> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum</span></p>';

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    currentPos = 0;
    minutos = 0;
    segundos = 0;
    _controller = VideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/welearn-4b24d.appspot.com/o/big_buck_bunny_720p_20mb.mp4?alt=media&token=bc2b9932-8eea-4795-82a0-8e611033e110');
    _controller.initialize().then((_) {
      inicial = _controller.value.duration.inSeconds;
      while (inicial > 60) {
        inicialm++;
        inicial = inicial - 60;
      }

      setState(() {
        _controller.setVolume(0.0);
        _controller.play();
        segundos = inicial;
        minutos = inicialm;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Icon miicono = Icon(
      FontAwesomeIcons.pause,
      size: MediaQuery.of(context).devicePixelRatio * 6,
    );
    _controller.addListener(() {
      _controller.value.position.inSeconds != currentPos
          ? setState(() {
              currentPos = _controller.value.position.inSeconds;
            })
          : _controller.value.position.inSeconds;

      _controller.value.position == _controller.value.duration
          ? setState(() {
              miicono = Icon(
                Icons.replay,
                size: MediaQuery.of(context).devicePixelRatio * 6,
              );
            })
          : null;
    });
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
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    child: _controller.value.initialized &&
                            _controller.value.position.inMilliseconds != 0
                        ? AspectRatio(
                            aspectRatio: 1.78,
                            child: VideoPlayer(
                              _controller,
                            ),
                          )
                        : Container(
                            child: AspectRatio(
                              aspectRatio: 1.78,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Color.fromARGB(0, 0, 0, 0),
                          Color.fromARGB(5, 0, 0, 0),
                          Color.fromARGB(15, 0, 0, 0),
                          Color.fromARGB(180, 0, 0, 0),
                        ])),
                    child: AspectRatio(
                      aspectRatio:1.78,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _controller.value.isPlaying
                                          ? _controller.pause()
                                          : _controller.play();

                                      if (_controller.value.position ==
                                          _controller.value.duration) {
                                        setState(() {
                                          _controller
                                              .seekTo(Duration(seconds: 0));
                                          currentPos = 0;
                                        });
                                      }
                                    });
                                  },
                                  color: Colors.white,
                                  icon: !_controller.value.isPlaying
                                      ? Icon(
                                          FontAwesomeIcons.play,
                                          size: MediaQuery.of(context)
                                                  .devicePixelRatio *
                                              6,
                                        )
                                      : miicono),
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                width: MediaQuery.of(context).size.width * .65,
                                child: FAProgressBar(
                                  size: 5,
                                  backgroundColor: Color.fromARGB(50, 0, 0, 0),
                                  progressColor: Colors.teal,
                                  currentValue:
                                      _controller.value.position != null
                                          ? currentPos
                                          : 0.0,
                                  maxValue: _controller.value.duration != null
                                      ? _controller.value.duration.inSeconds
                                          .toInt()
                                      : 100,
                                ),
                              ),
                              Text(
                                "$minutos:$segundos",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(Icons.fullscreen),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FullScreenVideo(
                                                videoFullscreen: _controller,
                                                minutos: minutos,
                                                segundos: segundos,
                                              )));
                                },
                                color: Colors.white,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .5,
              child: ListView(
                children: <Widget>[
                  HTML.HtmlWidget(
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
  void dispose() {
    _controller.dispose().then((f) {
      print("Cerro el video");
    });

    super.dispose();
  }
}
