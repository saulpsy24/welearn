import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/styles/styles.dart';

class MyCourseCard extends StatefulWidget {
  final String courseTitle;
  final int currentProgress;
  final String courseImage;
  final String courseId;

  MyCourseCard(
      {this.courseTitle,
      this.currentProgress,
      this.courseImage,
      this.courseId});

  @override
  _MyCourseCardState createState() => _MyCourseCardState();
}

class _MyCourseCardState extends State<MyCourseCard> {
  final Color color = Color.fromARGB(150, 0, 0, 0);

  int numeroLecciones = 0;
  int rebuild;
  var unidades;
  QuerySnapshot lecciones;
  @override
  void initState() {
    void getunidades() async {
      unidades = await Firestore.instance
          .collection('course_units')
          .where('course_id', isEqualTo: widget.courseId)
          .getDocuments();
      unidades.documents.forEach((DocumentSnapshot unidad) async {
        lecciones = await Firestore.instance
            .collection('lessons')
            .where('unit_id', isEqualTo: unidad.documentID)
            .getDocuments();

        setState(() {
          numeroLecciones = numeroLecciones + lecciones.documents.length;

          print(numeroLecciones);
        });
      });
    }

    getunidades();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    var mainProvider = Provider.of<MainProvider>(context);

    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        image: DecorationImage(
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          image: NetworkImage(widget.courseImage),
        ),
      ),
      child: Container(
        width: w * .55,
        height: h * .10,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(17)),
        child: ListView(
          children: <Widget>[
            //titulo del curso
            Container(
              width: w * .45,
              margin: EdgeInsets.only(top: 25),
              child: Text(
                widget.courseTitle,
                style: TextStyle(
                    color: Colors.white, fontFamily: 'hero', fontSize: 17),
              ),
            ),
            //duracion del curso
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
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('completed')
                      .where('uid', isEqualTo: mainProvider.currentUser.uid)
                      .where('c_id', isEqualTo: widget.courseId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> lessonsCompleted) {
                    if (lessonsCompleted.hasError)
                      return new Text('Error: ${lessonsCompleted.error}');
                    switch (lessonsCompleted.connectionState) {
                      case ConnectionState.waiting:
                        return new Text('Loading...');
                      default:
                        {
                          lessonsCompleted.data.documents.length != 0
                              ? mainProvider.setProgreso =
                                  (lessonsCompleted.data.documents.length *
                                          100) ~/
                                      (numeroLecciones != 0 ? numeroLecciones : 1)
                              : mainProvider.setProgreso = 0;
                          return Container(
                            width: MediaQuery.of(context).size.width * .45,
                            child: FAProgressBar(
                              progressColor: primary,
                              backgroundColor:
                                  Color.fromARGB(100, 255, 255, 255),
                              direction: Axis.horizontal,
                              size: 15,
                              maxValue: 100,
                              currentValue: mainProvider.getProgreso,
                              displayText: '% Completo',
                            ),
                          );
                        }
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
