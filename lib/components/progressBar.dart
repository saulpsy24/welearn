import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProgressPercent extends StatelessWidget {
  // Obtener el progreso del usuario
  obtenerTotalLecciones(String usuario) async {
    Firestore.instance
        .collection('course_enroll')
        .where("uid", isEqualTo: usuario)
        .snapshots()
        .listen((data) => data.documents.forEach((inscripcion) {
              Firestore.instance
                  .collection('courses')
                  .document(inscripcion.data['course_id'])
                  .get()
                  .then((DocumentSnapshot course) {
                Firestore.instance
                    .collection('course_units')
                    .where("course_id", isEqualTo: course.documentID)
                    .snapshots()
                    .listen((unidades) => unidades.documents.forEach((unidad) {
                          Firestore.instance
                              .collection('lessons')
                              .where("unit_id", isEqualTo: unidad.documentID)
                              .snapshots()
                              .listen((lecciones) {
                          }).onDone(()=>print("obtuvimos las lecciones"));
                        }));
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('books').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['title']),
                  subtitle: new Text(document['author']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
