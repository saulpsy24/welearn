import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/login.dart';
import 'package:welearn/styles/styles.dart';

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
                      return new Text('Loading...');
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
                              FlatButton(
                                onPressed: () {
                                  FirebaseAuth.instance
                                      .signOut()
                                      .then((onValue) {
                                    final page = LoginPage();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => page));
                                  });
                                },
                                child: Text('Log Out',
                                    style: TextStyle(color: Colors.redAccent)),
                              )
                            ],
                          );
                        }).toList(),
                      );
                  }
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .03),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.black38,
                  width: .5,
                ))),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: Center(
                          child: FlatButton(
                              onPressed: () {},
                              child: Text(
                                'General',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'hero',
                                    fontSize: 16),
                              )),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: Center(
                          child: FlatButton(
                              onPressed: () {},
                              child: Text(
                                'Cursos',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'hero',
                                    fontSize: 16),
                              )),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: Center(
                          child: FlatButton(
                              onPressed: () {},
                              child: Text(
                                'Completos',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'hero',
                                    fontSize: 16),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .5,
                      child: FlChart(
                          chart: PieChart(
                        PieChartData(
                          centerSpaceRadius: 50,
                          sections: [
                            PieChartSectionData(
                                value: 5,
                                radius: 100,
                                title: 'Tiempo',
                                color: primary,
                                titleStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'hero',
                                    fontWeight: FontWeight.bold)),
                            PieChartSectionData(
                                value: 3,
                                title: 'Cursos',
                                radius: 90,
                                color: Colors.cyan,
                                titleStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'hero',
                                    fontWeight: FontWeight.bold)),
                            PieChartSectionData(
                                value: 3,
                                radius: 85,
                                title: 'Actividades',
                                titleStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'hero',
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                    ),
                  ),
                ],
              )
            ],
          )
        : Center(
            child: Container(),
          );
  }
}
