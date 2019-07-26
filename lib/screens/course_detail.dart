import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/lessonpage.dart';
import 'package:welearn/screens/unit_lessons.dart';
import 'package:welearn/styles/styles.dart';

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
                  brightness: Brightness.light,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.black),
                  title: Text(
                    ds.data["name"],
                    style: TextStyle(color: Colors.black, fontFamily: 'hero'),
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
                            padding: EdgeInsets.only(bottom: 10),
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
                      height: MediaQuery.of(context).size.height * .18,
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * .04),
                      child: Center(
                          child: Text(
                        ds.data["description"],
                        style: TextStyle(
                            fontFamily: 'hero', fontWeight: FontWeight.w600),
                      )),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * .40,
                      child: ListView(
                        children: <Widget>[
                          for (int i = 1; i < 9; i++)
                            Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 2, color: Colors.black45)
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(6),
                                child: ExpandablePanel(
                                  header: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.school,
                                          size: 19,
                                        ),
                                        Text("   Unidad $i"),
                                      ],
                                    ),
                                  ),
                                  collapsed: Text(
                                    ds.data["description"],
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  expanded: GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LessonsPage()));
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          ds.data["description"],
                                          softWrap: true,
                                          style: TextStyle(fontFamily: 'hero'),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LessonsPage()));
                                          },
                                          child: Text(
                                            "Entrar",
                                            style: TextStyle(
                                                fontFamily: 'hero',
                                                color: primary,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  tapHeaderToExpand: true,
                                  hasIcon: true,
                                ))
                        ],
                      ),
                    )
                  ],
                ),
                floatingActionButton: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: FloatingActionButton.extended(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    shape: StadiumBorder(),
                    onPressed: () {},
                    backgroundColor: primary,
                    elevation: 1,
                    icon: Icon(FontAwesomeIcons.dollarSign),
                    label: Text(ds.data["price"] != "FREE"
                        ? ds.data["price"] + 'MXN'
                        : ds.data["price"]),
                  ),
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
