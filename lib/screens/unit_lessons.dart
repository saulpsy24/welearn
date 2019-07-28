import 'package:flutter/material.dart';
import 'package:welearn/screens/lessonpage.dart';

class LessonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Unidad 1",
          style: TextStyle(color: Colors.black, fontFamily: 'hero'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            for (int i = 0; i < 5; i++)
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LessonPage()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * .2,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.width * .05),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(100, 0, 0, 0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            image: AssetImage('assets/patron.jpg'),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(100, 0, 0, 0),
                                blurRadius: 5)
                          ],
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * .15,
                              height: MediaQuery.of(context).size.width * .15,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/welearn-4b24d.appspot.com/o/web-programming.png?alt=media&token=5e4df30b-1b37-4459-a557-5dc25c53def7"),
                              )),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(120, 0, 0, 0),
                              ),
                              child: Text('Leccion $i',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'hero',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
