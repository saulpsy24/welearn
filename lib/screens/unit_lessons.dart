import 'dart:ui' as prefix0;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/lessonpage.dart';
import 'package:welearn/styles/styles.dart';

class LessonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          mainProvider.unitName,
          style: TextStyle(color: Colors.black, fontFamily: 'hero'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(MediaQuery.of(context).size.width * .05),
                  bottomRight:
                      Radius.circular(MediaQuery.of(context).size.width * .05)),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(100, 0, 0, 0),
                    spreadRadius: 2,
                    blurRadius: 1),
              ],
            ),
            height: MediaQuery.of(context).size.width * .40,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('course_units')
                  .where("course_id", isEqualTo: mainProvider.courseId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return new ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return InkWell(
                          focusColor: primary,
                          splashColor: primary,
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * .25),
                          onTap: () {
                            mainProvider.unitName = document.data["unit_name"];
                            mainProvider.unitInfo = document;
                          },
                          child: Container(
                            margin: EdgeInsets.all(7),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * .25,
                                  width:
                                      MediaQuery.of(context).size.width * .25,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: primary, width: 3),
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              .25),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              document.data["unit_image"]))),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.width * .2,
                                    width:
                                        MediaQuery.of(context).size.width * .2,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .25,
                                  child: Text(
                                    document.data["unit_name"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'hero',
                                        fontSize: 10),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * .635,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('lessons')
                    .where('unit_id',
                        isEqualTo: mainProvider.unitInfo.documentID)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      {
                        return new ListView(
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            return GestureDetector(
                              onTap: () {
                                mainProvider.setLessons =
                                    snapshot.data.documents;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LessonPage(lesson: document,),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * .02),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      document.data["lesson_image"],
                                    ),
                                  ),
                                ),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(200, 60, 150, 165),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: Text(
                                    document.data["lesson_title"],
                                    style: TextStyle(
                                        shadows: [
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 5,
                                              offset:
                                                  Offset.fromDirection(5, 1))
                                        ],
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontFamily: 'hero',
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                  }
                },
              )),
        ],
      ),
    );
  }
}
