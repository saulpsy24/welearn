import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:welearn/styles/styles.dart';
import 'package:chewie/chewie.dart';

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
        });
      });
   
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Center(
          child: _controller.value.initialized
              ? Container(
                  color: Colors.black,
                  child: Chewie(
                    controller: _chewieController,
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.width / 1.7,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      backgroundColor: primary,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  void dispose() {
    _controller.dispose();
    _chewieController.dispose();

    super.dispose();
  }
}
