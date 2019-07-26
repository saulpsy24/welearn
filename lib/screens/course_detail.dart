import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:welearn/providers/provider.dart';

class CourseDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    return FutureBuilder<DocumentSnapshot>(
      future: Firestore.instance
          .collection('courses')
          .document(mainProvider.courseId)
          .get(),
      builder: (BuildContext context, AsyncSnapshot ds) {
        return ds.hasData
            ? Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.black),
                  title: Text(
                    ds.hasData ? ds.data["name"] : "Cargando..",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                body: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * .25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(10)),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    ds.data["image"],
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * .25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(10)),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(0, 0, 0, 0),
                                    Color.fromARGB(10, 0, 0, 0),
                                    Color.fromARGB(190, 0, 0, 0)
                                  ]),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * .25,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(10)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (int i = 0;
                                    i < int.parse(ds.data["rating"]);
                                    i++)
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .95,
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * .04),
                      child: Center(child: Text(ds.data["description"])),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*.40,
                      child: ListView(
                        itemExtent: 100,
                        children: <Widget>[
                          for(int i=1;i<9;i++)
                          ExpansionTile(
                            title: Text("Unidad $i"),
                            leading: Icon(FontAwesomeIcons.university),
                            children: <Widget>[
                              Text("Descripcion de la unidad")
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}
