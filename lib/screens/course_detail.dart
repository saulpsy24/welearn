import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:welearn/components/incluye_card.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/live_class.dart';
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
                      height: MediaQuery.of(context).size.height * .7,
                      child: ListView(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  ds.data["name"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontFamily: 'hero',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  ds.data["description"],
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontFamily: 'hero',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  "Este curso incluye",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'hero',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: MediaQuery.of(context).size.width * .28,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LiveStreamClass()));
                                      },
                                      child: IncludeCard(
                                        title: 'Clases en Vivo',
                                        icono: Icon(
                                          Icons.table_chart,
                                          color: primary,
                                        ),
                                      ),
                                    ),
                                    IncludeCard(
                                      title: 'Videos Tutoriales',
                                      icono: Icon(
                                        Icons.play_arrow,
                                        color: primary,
                                      ),
                                    ),
                                    IncludeCard(
                                      title: 'Material Didáctico',
                                      icono: Icon(
                                        Icons.wb_iridescent,
                                        color: primary,
                                      ),
                                    ),
                                    IncludeCard(
                                      title: 'Exámenes',
                                      icono: Icon(
                                        Icons.view_module,
                                        color: primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 100,
                              child: MaterialButton(
                                shape: StadiumBorder(),
                                onPressed: () {},
                                color: primary,
                                child: Text(
                                  'Entrar al Curso',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'hero',
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection('course_units')
                                .where("course_id",
                                    isEqualTo: mainProvider.courseId)
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
                                      return Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                document.data["unit_image"]),
                                          ),
                                        ),
                                        child: new Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                    colors: [
                                                      Color.fromARGB(
                                                          250, 30, 150, 156),
                                                      Color.fromARGB(
                                                          150, 30, 150, 156)
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Container(
                                              child: ExpandablePanel(
                                                header: Center(
                                                  child: Text(
                                                    document.data["unit_name"],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'hero',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                collapsed: Text(
                                                  document
                                                      .data["unit_description"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontFamily: 'hero'),
                                                  softWrap: true,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                expanded: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LessonsPage()));
                                                  },
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        document.data[
                                                            "unit_description"],
                                                        softWrap: true,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'hero',
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      FlatButton(
                                                        shape: StadiumBorder(),
                                                        color: primary,
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          LessonsPage()));
                                                        },
                                                        child: Text(
                                                          "Entrar",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'hero',
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                tapHeaderToExpand: true,
                                                hasIcon: true,
                                              ),
                                            )),
                                      );
                                    }).toList(),
                                  );
                              }
                            },
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[],
                            ),
                          )
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
