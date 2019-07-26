import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyCourseCard extends StatelessWidget {
  final String courseTitle;
  final Color color = Color.fromARGB(150, 0, 0, 0);
  final int currentProgress;
  MyCourseCard({this.courseTitle, this.currentProgress});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        image: DecorationImage(
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          image: AssetImage('assets/patron.jpg'),
          
        ),
      ),
      child: Container(
        width: w * .55,
        height: h * .10,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(17)),
        child: Column(
          children: <Widget>[
            Container(
              width: w * .45,
              margin: EdgeInsets.only(top: 25),
              child: Text(
                courseTitle,
                style: TextStyle(
                    color: Colors.white, fontFamily: 'hero', fontSize: 17),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    FontAwesomeIcons.clock,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Text(
                    'Quedan 5 días',
                    style: TextStyle(color: Colors.white, fontFamily: 'hero'),
                  ),
                )
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*.05),
                    child: FAProgressBar(
                      currentValue: currentProgress,
                      displayText: "%Completo",
                      borderRadius: 2,
                      size: 15,
                      backgroundColor: Color.fromARGB(50, 0, 0, 0),
                      changeProgressColor: Colors.white,
                      progressColor: Color.fromARGB(200, 0 , 0, 0),
                      direction: Axis.horizontal,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
