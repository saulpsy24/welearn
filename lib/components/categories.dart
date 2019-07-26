import 'package:flutter/material.dart';

class CategoriCard extends StatelessWidget {
  final String image;
  final String  name;
  CategoriCard({this.image, this.name});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * .2,
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * .05),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color.fromARGB(100, 0, 0, 0), blurRadius: 5)
            ],
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width*.15,
                height: MediaQuery.of(context).size.width*.15 ,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(image),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Design',
                    style: TextStyle(fontFamily: 'hero', fontSize: 18)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
