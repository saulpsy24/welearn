import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/course_detail.dart';

void main() => runApp(MaterialApp(home: QRViewExample()));

class QRViewExample extends StatefulWidget {
  const QRViewExample({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;
  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Escanea el QR', style: TextStyle(fontFamily: "hero")),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
            flex: 4,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  shape: StadiumBorder(),
                  color: Colors.red,
                  onPressed: () {
                    if (controller != null) {
                      controller.toggleFlash();
                    }
                  },
                  child: Text('Flash',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'hero')),
                )
              ],
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    var miProvider = Provider.of<MainProvider>(context);

    controller.scannedDataStream.listen((scanData) async {
      controller.dispose();
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CourseDetail(
                    courseId: scanData,
                    userId: miProvider.currentUser.uid,
                  ))).then((val) {
        controller.dispose();

        miProvider.courseId = scanData;
      });
    });
  }
}
