import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tab3 extends StatefulWidget {
  @override
  _Tab3State createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('news').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(
                          child: CircularProgressIndicator(),
                        );
          default:
            {
              print(snapshot.data.documents);
              return new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return Card(
                    child: new ListTile(
                      title: new Text(document['news_title']),
                      subtitle: new Text(document['news_body']),
                    ),
                  );
                }).toList(),
              );
            }
        }
      },
    );
  }
}
