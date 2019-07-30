import 'package:flutter/material.dart';

class IncludeCard extends StatelessWidget {
  final Icon icono;
  final String title;
  IncludeCard({this.icono, this.title});
  @override
  Widget build(BuildContext context) {
    return Container(

      width: MediaQuery.of(context).size.width * .28,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(50, 0, 0, 0),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icono,
          Text(
            title,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(fontFamily: 'hero', fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
