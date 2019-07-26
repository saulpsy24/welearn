import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:welearn/components/categories.dart';
import 'package:welearn/screens/initial.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        title: Text(
          'Selecciona tus Intereses',
          style: TextStyle(
              color: Colors.black87, fontFamily: 'hero', fontSize: 17),
        ),
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.black38),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              final page = RootPage();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => page));
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('course_category').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new GridView.count(
              crossAxisCount: 2,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return   Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    CategoriCard(image: document.data["image"],name: document.data["name"],),
                  ],
                );
              }).toList(),
            );
        }
      },
    ),
  );
  }
}
