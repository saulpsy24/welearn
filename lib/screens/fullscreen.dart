import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideo extends StatefulWidget {
  VideoPlayerController videoFullscreen;
  int minutos;
  int segundos;
  FullScreenVideo({this.videoFullscreen, this.segundos, this.minutos});
  @override
  _FullScreenVideoState createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  int currentPos;
  int minutos;
  int segundos;
  int inicial;
  int inicialm = 0;

  double cwith;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  VideoPlayerController _controller;
  @override
  void initState() {
    setState(() {
      _controller = widget.videoFullscreen;
      minutos = widget.minutos;
      segundos = widget.segundos;
      cwith = 0;
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Icon miicono = Icon(
      FontAwesomeIcons.pause,
      size: MediaQuery.of(context).devicePixelRatio * 6,
    );
    _controller.addListener(() {
      if (mounted) {
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

        var asr = _controller.value.position.inSeconds.toInt() *
            (MediaQuery.of(context).size.width * .65) /
            _controller.value.duration.inSeconds.toInt();
        setState(() {
          cwith = asr;
        });
      }
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
              child: _controller.value.initialized &&
                      _controller.value.position.inMilliseconds != 0
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(
                        _controller,
                      ),
                    )
                  : Container(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
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
                aspectRatio: 1.78,
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
                                    _controller.seekTo(Duration(seconds: 0));
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
                        Stack(
                          children: <Widget>[
                            AnimatedContainer(
                              width: cwith.toDouble(),
                              color: Colors.red,
                              height: MediaQuery.of(context).size.height * .009,
                              duration: Duration(milliseconds: 1000),
                            ),
                            Container(
                              color: Color.fromARGB(25, 255, 255, 255),
                              height: MediaQuery.of(context).size.height * .009,
                              width: MediaQuery.of(context).size.width * .65,
                            ),
                          ],
                        ),
                        Text(
                          "$minutos:$segundos",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.fullscreen_exit),
                          onPressed: () {
                            Navigator.pop(context);
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
    );
  }
  @override
  void dispose() {SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
    super.dispose();
  }
}
