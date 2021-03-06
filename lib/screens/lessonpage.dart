import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as HTML;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/fullscreen.dart';
import 'package:welearn/styles/styles.dart';

class LessonPage extends StatefulWidget {
  final DocumentSnapshot lesson;
  final String uid;
  final String cid;
  LessonPage({this.lesson, this.cid, this.uid});
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
  int index = 0;
  String video;

  String webContent;
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
    setState(() {
      webContent = widget.lesson.data["lesson_content"];

      video = widget.lesson.data["lesson_video"];
    });

    _controller = VideoPlayerController.network(video);
    _controller.initialize().then((_) {
      inicial = _controller.value.duration.inSeconds;
      while (inicial > 60) {
        inicialm++;
        inicial = inicial - 60;
      }
      setState(() {
        _controller.setVolume(100.0);
        _controller.play();
        segundos = inicial;
        minutos = inicialm;
        index = 0;
      });
    });
    void addCompleted() async {
      Firestore.instance
          .collection('completed')
          .where("uid", isEqualTo: widget.uid)
          .where('c_id', isEqualTo: widget.cid)
          .where('l_id', isEqualTo: widget.lesson.documentID)
          .snapshots()
          .listen((completados) {
        if (completados.documents.length == 0) {
          Map<String, dynamic> uid = new Map<String, dynamic>();
          uid["uid"] = widget.uid;
          uid["c_id"] = widget.cid;
          uid["l_id"] = widget.lesson.documentID;

          DocumentReference currentRegion =
              Firestore.instance.collection("completed").document();

          Firestore.instance.runTransaction((transaction) async {
            await transaction.set(currentRegion, uid);
            print("instance created");
          });
        }
      });
    }

    addCompleted();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<MainProvider>(context);
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          mainProvider.getLesson.data["lesson_title"],
          style: TextStyle(color: Colors.black, fontFamily: 'hero'),
        ),
      ),
      body: SlidingUpPanel(
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
                                width: MediaQuery.of(context).size.width * .65,
                                child: CupertinoSlider(
                                  activeColor: primary,
                                  onChanged: (val) {
                                    _controller
                                        .seekTo(Duration(seconds: val.toInt()));
                                  },
                                  onChangeEnd: (newval) {
                                    _controller.seekTo(
                                        Duration(seconds: newval.toInt()));
                                  },
                                  max: _controller.value.duration != null
                                      ? _controller.value.duration.inSeconds
                                          .toDouble()
                                      : 100,
                                  min: 0.0,
                                  value: _controller.value.position != null
                                      ? _controller.value.position.inSeconds
                                          .toDouble()
                                      : 0.0,
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
              )),
              Container(
                height: MediaQuery.of(context).size.height * .5,
                child: ListView(
                  children: <Widget>[
                    webContent != null
                        ? HTML.HtmlWidget(
                            webContent,
                            webView: true,
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
        margin: EdgeInsets.only(top: 120),
        panel: Container(
          margin: EdgeInsets.only(top: 25),
          child: ListView(
            children: <Widget>[
              for (int index = 0;
                  index < mainProvider.getLessons.length;
                  index++)
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LessonPage(
                                  lesson: mainProvider.getLessons[index],
                                  uid: widget.uid,
                                  cid: widget.cid,
                                )));
                    mainProvider.setLesson = mainProvider.getLessons[index];
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * .09,
                          width: MediaQuery.of(context).size.height * .09,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black38),
                              BoxShadow(color: Colors.black38)
                            ],
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height * .005),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              alignment: Alignment.centerLeft,
                              image: NetworkImage(mainProvider
                                  .getLessons[index].data["lesson_image"]),
                            ),
                          ),
                          child: Container(),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .35,
                          child: Text(
                            mainProvider.getLessons[index].data["lesson_title"],
                            style:
                                TextStyle(color: Colors.black, fontFamily: 'hero',fontWeight: FontWeight.bold,fontSize: 20),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        collapsed: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(100, 0, 0, 0),
              ),
              height: 5,
            )
          ],
        ),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        parallaxEnabled: true,
        backdropEnabled: true,
        minHeight: MediaQuery.of(context).size.height * .07,

        maxHeight: MediaQuery.of(context).size.height * .4,
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
