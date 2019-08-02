import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welearn/components/recomended_card.dart';
import 'package:welearn/providers/provider.dart';

import 'course_detail.dart';

class SeeFree extends StatelessWidget {
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
          'Cursos Gratis',
          style: TextStyle(color: Colors.black, fontFamily: 'hero'),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('courses')
            .where("price", isEqualTo: 'FREE')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Container(
                height: MediaQuery.of(context).size.height * .85,
                child: new GridView(
                  cacheExtent: 200,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 1,
                    childAspectRatio: .7,
                      crossAxisCount: 2),
                  scrollDirection: Axis.vertical,
                  
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return InkWell(
                        onTap: () {
                          mainProvider.courseId = document.documentID;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CourseDetail()));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height*.16,
                          child: RecomendedCard(
                            image: document.data['image'],
                            title: document.data['name'],
                            rating: document.data['rating'],
                            price: document.data["price"],
                          ),
                        ));
                  }).toList(),
                ),
              );
          }
        },
      ),
    );
  }
}
