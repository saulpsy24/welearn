import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class LiveStreamClass extends StatelessWidget {
  String webContent =
      '<h1 style="text-align: center;">Titulo de la lección</h1><img height=20px; style="display:block;width:50%;heigth:10px;" src="https://disolutionsmx.com/images/Logo.png"/><p style="text-align: center;"><strong>Lorem Ipsum</strong><span> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum</span></p><h1 style="text-align: center;">Titulo de la lección</h1><p style="text-align: center;"><strong>Lorem Ipsum</strong><span> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum</span></p>';
  final String _ytVideo =
      '<iframe width="560" height="315" src="https://www.youtube.com/embed/kdtkyYid7YA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        title: Text(
          'Clase en Vivo',
          style: TextStyle(color: Colors.black, fontFamily: 'hero'),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              HtmlWidget(
                _ytVideo + webContent,
                webView: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
