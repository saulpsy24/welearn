import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/login.dart';

class Tab2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    return mainProvider.currentUser != null
        ? ListView(
          
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .where("user_id", isEqualTo: mainProvider.currentUser.uid)
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
                      return new Column(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * .3,
                                height: MediaQuery.of(context).size.width * .3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * .3),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(document.data['picture']),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  document.data['name'] +
                                      " " +
                                      document.data["surname"],
                                  style: TextStyle(
                                      fontFamily: 'hero', fontSize: 18),
                                ),
                              ),
                              Container(
                                child: Text(
                                  document.data['country'],
                                  style: TextStyle(
                                      fontFamily: 'hero',
                                      fontSize: 13,
                                      color: Colors.black45),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                  }
                },
              ),
              FlatButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((onValue) {
                    final page = LoginPage();
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => page));
                  });
                },
                child:
                    Text('Log Out', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          )
        : Center(
            child: Container(),
          );
  }
}
