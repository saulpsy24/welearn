import 'package:flutter/material.dart';

class RecomendedCard extends StatelessWidget {
  final String image;
  final String title;
  final String rating;
  final String price;
  RecomendedCard({this.image, this.title, this.rating, this.price});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.all(10),
      height: h * .30,
      width: w * .40,
      child: Column(
        children: <Widget>[
          Container(
            width: w * .40,
            height: h * .15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(17)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  this.image,
                ),
              ),
            ),
          ),
          Container(
            child: Container(
              width: w * .40,
              height: h * .15,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset.fromDirection(5, -5),
                      blurRadius: 10,
                      spreadRadius: 1)
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(17),
                  bottomRight: Radius.circular(17),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Text(
                      title,
                      style: TextStyle(fontFamily: 'hero'),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          for (int i = 0; i < int.parse(rating); i++)
                            Icon(
                              Icons.star,
                              size: 15,
                            ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: price != "FREE"
                        ? Text(
                            r"$" + price,
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'hero',
                                fontSize: 20),
                          )
                        : Text(
                            price,
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'hero',
                                fontSize: 20),
                          ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
