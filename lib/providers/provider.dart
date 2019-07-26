import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:welearn/components/mycourses_card.dart';

class MainProvider with ChangeNotifier {
  //Guardar el Usuario que se loggeo
  FirebaseUser _currentUser;

  FirebaseUser get currentUser => _currentUser;

  set currentUser(FirebaseUser usuario) {
    _currentUser = usuario;
    notifyListeners();
  }

  //page Controller
  int _page = 0;
  int get page => _page;
  set page(int newPage) {
    _page = newPage;
    notifyListeners();
  }

  //page Title

  String _pageName = "INICIO";
  String get pageName => _pageName;
  set pageName(String newTitle) {
    _pageName = newTitle;
    notifyListeners();
  }

  String _videoUrl =
      'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4';

  String get videourl => _videoUrl;
  set videourl(String nvideourl) {
    _videoUrl = nvideourl;
    notifyListeners();
  }

  VideoPlayerController _videoController = VideoPlayerController.network(
      "http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4")
    ..initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    });

  VideoPlayerController get videoController => _videoController;
  set videoController(VideoPlayerController newVid) {
    _videoController = newVid;
    notifyListeners();
  }

  List<Widget> _mCI = [MyCourseCard(),MyCourseCard()];

  List<Widget> get myCourses =>_mCI;

  set myCourses(List<Widget>myWidget){
    _mCI=myWidget;
    notifyListeners();
  }

  bool _courseFlag = false;
  get courseFlag =>_courseFlag;
  set courseFlag(bool newState){
    _courseFlag=newState;
    notifyListeners();
  }

  //Guardamos el id DEL CURSO
  String _courseId="";

  String get  courseId=>_courseId;

  set courseId(String newId){
    _courseId=newId;
    notifyListeners();
  }

}
