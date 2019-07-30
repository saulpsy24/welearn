import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welearn/components/mycourses_card.dart';
import 'package:welearn/components/recomended_card.dart';
import 'package:welearn/providers/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:welearn/screens/course_detail.dart';

class Tab1 extends StatelessWidget {
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
              child: Text(
                'Ver Todo',
                style: TextStyle(
                    fontFamily: 'hero', fontSize: 17, color: Colors.black45),
              ),
            )
          ],
        ),
        Container(
          height: 200,
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('course_enroll')
                .where('uid', isEqualTo: mainProvider.currentUser.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return new ListView(
                    itemExtent: MediaQuery.of(context).size.width * .55,
                    scrollDirection: Axis.horizontal,
                    //En documents guardamos toddas las inscripciones del usuario, luego mapeamos, y jalamos en document el detalle de cada curso
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return FutureBuilder<DocumentSnapshot>(
                          future: Firestore.instance
                              .collection("courses")
                              .document(document.data["course_id"])
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> documents) {
                            switch (documents.connectionState) {
                              case ConnectionState.none:
                                return Text('Press button to start.');
                              case ConnectionState.active:
                              case ConnectionState.waiting:
                                return Text('Awaiting result...');
                              case ConnectionState.done:
                                if (documents.hasError)
                                  return Text('Error: ${documents.error}');
                                return GestureDetector(
                                  onTap: (){
                                    
                                    final page = CourseDetail();
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
                                    mainProvider.courseId=document.data["course_id"];
                                  },
                                  child: MyCourseCard(
                                    courseTitle: documents.data["name"],
                                    currentProgress: document.data["progress"],
                                    courseImage: documents.data["image"],
                                  ),
                                );
                            }
                            return Container();
                          });
                    }).toList(),
                  );
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
              child: Text(
                'Ver Todo',
                style: TextStyle(
                    fontFamily: 'hero', fontSize: 17, color: Colors.black45),
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
                      return RecomendedCard(
                        image: document.data['image'],
                        title: document.data['name'],
                        rating: document.data['rating'],
                        price: document.data["price"],
                      );
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
              child: Text(
                'Ver Todo',
                style: TextStyle(
                    fontFamily: 'hero', fontSize: 17, color: Colors.black45),
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
                      return RecomendedCard(
                        image: document.data['image'],
                        title: document.data['name'],
                        rating: document.data['rating'],
                        price: document.data["price"],
                      );
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
