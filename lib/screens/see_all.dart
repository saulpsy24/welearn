import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welearn/components/mycourses_card.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/course_detailoficial.dart';


class SeeAllMC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Mis Cursos',
          style: TextStyle(color: Colors.black, fontFamily: 'hero'),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * .8,
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
                return new GridView(
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  scrollDirection: Axis.vertical,
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
                                                  CourseDetailOficial(sku: curso.data["sku"],)));
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
          },
        ),
      ),
    );
  }
}
