import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/homescreen.dart';
import 'package:welearn/screens/login.dart';
import 'package:welearn/screens/profile_details.dart';
import 'package:welearn/styles/styles.dart';

class RegisterPage extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKeyr = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.height;
    var mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black38),
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
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
                    key: _fbKeyr,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: w * .07, vertical: h * .05),
                          child: FormBuilderTextField(
                            attribute: "email",
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline),
                                labelText: "Email",
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
                                    "Registrarme >",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Hero'),
                                  )),
                              onPressed: () {
                                _fbKeyr.currentState.save();
                                if (_fbKeyr.currentState.validate()) {
                                  FirebaseAuth.instance.createUserWithEmailAndPassword(email: _fbKeyr.currentState.value['email'],password: _fbKeyr.currentState.value['password']).then((userid){
                                   final page = ProfileSet();
                                   mainProvider.currentUser =userid;
                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>page));
                                  });
                                }
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: h * .1),
                              child: FlatButton(
                                child: RichText(
                                  text: TextSpan(
                                    text: '¿Ya tienes cuenta?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily: 'hero'),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' Inicia Sesión',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: accent)),
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                 final page = LoginPage();
                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>page));
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
}
