import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<QuerySnapshot>> userCourses(String uid) async {
  List<QuerySnapshot> cursos = await Firestore.instance
      .collection('course_enroll')
      .where("uid", isEqualTo: uid)
      .snapshots()
      .toList();

  cursos.map((rasult) {
    rasult.documents.map((inscripcion) {
      print(inscripcion.data["course_id"]);
    });
  });
  return cursos;
}
