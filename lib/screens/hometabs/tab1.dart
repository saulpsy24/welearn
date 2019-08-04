import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welearn/components/mycourses_card.dart';
import 'package:welearn/components/recomended_card.dart';
import 'package:welearn/providers/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:welearn/screens/course_detail.dart';
import 'package:welearn/screens/see_all.dart';
import 'package:welearn/screens/seeallfree.dart';
import 'package:welearn/screens/seeallrecomended.dart';
import 'package:welearn/styles/styles.dart';

class Tab1 extends StatefulWidget {
  final String uid;
  Tab1({this.uid});
  @override
  _Tab1State createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  QuerySnapshot inscripciones;
  double altura = 1;
  @override
  void initState() {
    void getInscripciones() async {
      inscripciones = await Firestore.instance
          .collection('course_enroll')
          .where('uid', isEqualTo: widget.uid)
          .getDocuments();

      if (inscripciones.documents.length == 0) {
        setState(() {
          altura = 10;
        });
      } else {
        setState(() {
          altura = 200;
        });
      }
    }

    getInscripciones();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Mis Cursos',
                  style: TextStyle(fontSize: 20, fontFamily: 'hero'),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: FlatButton(
                shape: StadiumBorder(),
                color: primary,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SeeAllMC()));
                },
                child: Text(
                  'Ver Todo',
                  style: TextStyle(
                      fontFamily: 'hero', fontSize: 17, color: Colors.white),
                ),
              ),
            )
          ],
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: altura,
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('course_enroll')
                .where('uid', isEqualTo: mainProvider.currentUser.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> inscripciones) {
              if (inscripciones.hasError)
                return new Text('Error: ${inscripciones.error}');
              switch (inscripciones.connectionState) {
                case ConnectionState.waiting:
                  return new Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  {
                    
                    return new ListView(
                      itemExtent: MediaQuery.of(context).size.width * .55,
                      scrollDirection: Axis.horizontal,
                      //En documents guardamos toddas las inscripciones del usuario, luego mapeamos, y jalamos en document el detalle de cada curso
                      children: inscripciones.data.documents
                          .map((DocumentSnapshot inscripcion) {
                        return FutureBuilder<DocumentSnapshot>(
                            future: Firestore.instance
                                .collection("courses")
                                .document(inscripcion.data["course_id"])
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> curso) {
                              switch (curso.connectionState) {
                                case ConnectionState.none:
                                  return Text('Press button to start.');
                                case ConnectionState.active:
                                case ConnectionState.waiting:
                                  return Center(child: CircularProgressIndicator(),);
                                case ConnectionState.done:
                                  {
                                    if (curso.hasError) {
                                      return Text('Error: ${curso.error}');
                                    } else {
                                      return InkWell(
                                        onTap: () {
                                          mainProvider.courseId =
                                              curso.data.documentID;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CourseDetail(
                                                        courseId: mainProvider
                                                            .courseId,
                                                        userId: mainProvider
                                                            .currentUser.uid,
                                                      )));
                                        },
                                        child: Container(
                                          child: MyCourseCard(
                                            courseId: curso.data.documentID,
                                            courseImage: curso.data["image"],
                                            courseTitle: curso.data["name"],
                                          ),
                                        ),
                                      );
                                    }
                                  }
                              }
                              return Container();
                            });
                      }).toList(),
                    );
                  }
              }
            },
          ),
        ),
        Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Recomendados',
                  style: TextStyle(fontSize: 20, fontFamily: 'hero'),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: FlatButton(
                shape: StadiumBorder(),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SeeAllRC()));
                },
                color: primary,
                child: Text(
                  'Ver Todo',
                  style: TextStyle(
                      fontFamily: 'hero', fontSize: 17, color: Colors.white),
                ),
              ),
            )
          ],
        ),
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('courses')
              .where("marked", isEqualTo: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return Container(
                  height: MediaQuery.of(context).size.height * .34,
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return InkWell(
                          onTap: () {
                            mainProvider.courseId = document.documentID;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CourseDetail(
                                          courseId: mainProvider.courseId,
                                          userId: mainProvider.currentUser.uid,
                                        )));
                          },
                          child: RecomendedCard(
                            image: document.data['image'],
                            title: document.data['name'],
                            rating: document.data['rating'],
                            price: document.data["price"],
                          ));
                    }).toList(),
                  ),
                );
            }
          },
        ),
        Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Cursos Gratis',
                  style: TextStyle(fontSize: 20, fontFamily: 'hero'),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SeeFree()));
                },
                color: primary,
                shape: StadiumBorder(),
                child: Text(
                  'Ver Todo',
                  style: TextStyle(
                      fontFamily: 'hero', fontSize: 17, color: Colors.white),
                ),
              ),
            )
          ],
        ),
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('courses')
              .where("price", isEqualTo: "FREE")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return Container(
                  height: MediaQuery.of(context).size.height * .34,
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return InkWell(
                          onTap: () {
                            mainProvider.courseId = document.documentID;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CourseDetail(
                                          courseId: mainProvider.courseId,
                                          userId: mainProvider.currentUser.uid,
                                        )));
                          },
                          child: RecomendedCard(
                            image: document.data['image'],
                            title: document.data['name'],
                            rating: document.data['rating'],
                            price: document.data["price"],
                          ));
                    }).toList(),
                  ),
                );
            }
          },
        ),
      ],
    );
  }
}
