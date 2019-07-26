import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:welearn/components/oninit.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/initial.dart';
import 'package:welearn/screens/register.dart';
import 'package:welearn/styles/styles.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.height;

    Widget _loginPage() {
      return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black38),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(h * .05),
                        height: h * .1,
                        width: h * .1,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/icon.png'))),
                      ),
                    ),
                    FormBuilder(
                      autovalidate: false,
                      key: _fbKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: w * .07, vertical: h * .05),
                            child: FormBuilderTextField(
                              attribute: "email",
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_outline),
                                  labelText: "Mail",
                                  labelStyle: TextStyle(
                                    fontFamily: 'Hero',
                                  )),
                              validators: [FormBuilderValidators.email()],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: h * .05, left: w * .07, right: w * .07),
                            child: FormBuilderTextField(
                              attribute: "password",
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: Icon(Icons.lock_outline),
                                  labelStyle: TextStyle(fontFamily: 'Hero')),
                              validators: [
                                FormBuilderValidators.minLength(6),
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () {},
                                  child: Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(
                                        color: primary,
                                        fontFamily: 'Hero',
                                        fontSize: 16),
                                  )),
                              MaterialButton(
                                shape: StadiumBorder(),
                                color: accent,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    child: Text(
                                      "Login >",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Hero'),
                                    )),
                                onPressed: () {
                                  _fbKey.currentState.save();
                                  if (_fbKey.currentState.validate()) {
                                    FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _fbKey
                                                .currentState.value['email'],
                                            password: _fbKey
                                                .currentState.value['password'])
                                        .then((user) {
                                      final page = RootPage();

                                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>page));
                                      mainProvider.currentUser = user;
                                      print(mainProvider.currentUser);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => page));
                                    }).catchError((onError) {
                                      Alert(
                                          context: context,
                                          title: onError.message,
                                          desc: onError.code,
                                          buttons: [
                                            DialogButton(
                                              color: primary,
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancelar',style: TextStyle(color: Colors.white,fontFamily: 'Hero'),),
                                            )
                                          ]).show();
                                    });
                                  }
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: h * .05),
                                child: FlatButton(
                                  child: RichText(
                                    text: TextSpan(
                                      text: '¿No tienes cuenta?',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontFamily: 'hero'),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ' Registrate',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: accent)),
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    final page = RegisterPage();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => page));
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return StatefulWrapper(
      onInit: () {
        FirebaseAuth.instance.currentUser().then((user) {
          mainProvider.currentUser = user;
          if (mainProvider.currentUser != null) {
            final page = RootPage();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => page));
          }
        });
      },
      child: _loginPage(),
    );
  }
}
