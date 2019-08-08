import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/initial.dart';
import 'package:welearn/screens/profile_details.dart';
import 'package:welearn/screens/register.dart';
import 'package:welearn/styles/styles.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool isloading = true;
  FirebaseUser usergot;
 void checkLogin () async {
   await FirebaseAuth.instance.currentUser().then((user) {
     usergot = user;
      
    });
 }
  @override
  void initState() {
     checkLogin();
     setState(() {
        isloading = false;
      });

    super.initState();
  }

  Widget _loginPage() {
    var mainProvider = Provider.of<MainProvider>(context);
    var h = MediaQuery.of(context).size.height;
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
                  Row(
                    children: <Widget>[
                      Container(
                          height: 150,
                          width: 150,
                          child: FlareActor("assets/logo.flr",
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              animation: "Untitled")),
                      Container(
                        child: Text('WeLearning',
                            style: TextStyle(
                                fontFamily: 'hero',
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                      )
                    ],
                  ),
                  FormBuilder(
                    autovalidate: false,
                    key: _fbKey,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .05,
                          bottom: MediaQuery.of(context).size.height * .05),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontFamily: 'hero',
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              FormBuilderTextField(
                                attribute: "email",
                                decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.person_outline),
                                    labelText: "Mail",
                                    disabledBorder: InputBorder.none,
                                    labelStyle: TextStyle(
                                      fontFamily: 'Hero',
                                    )),
                                validators: [FormBuilderValidators.email()],
                              ),
                              FormBuilderTextField(
                                attribute: "password",
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    suffixIcon: Icon(Icons.lock_outline),
                                    labelStyle: TextStyle(fontFamily: 'Hero')),
                                validators: [
                                  FormBuilderValidators.minLength(6),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: MaterialButton(
                          shape: StadiumBorder(),
                          color: accent,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Text(
                                "Login",
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
                                      email: _fbKey.currentState.value['email'],
                                      password:
                                          _fbKey.currentState.value['password'])
                                  .then((user) async {
                                QuerySnapshot profile = await Firestore.instance
                                    .collection('users')
                                    .where("user_id", isEqualTo: user.uid)
                                    .getDocuments();

                                if (profile.documents.length != 0) {
                                  final page = RootPage();
                                  mainProvider.page = 0;

                                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>page));
                                  mainProvider.currentUser = user;
                                  print(mainProvider.currentUser);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => page));
                                } else {
                                  final page = ProfileSet();
                                  mainProvider.page = 0;

                                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>page));
                                  mainProvider.currentUser = user;
                                  print(mainProvider.currentUser);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => page));
                                }
                              }).catchError((onError) {
                                Alert(
                                    context: context,
                                    title: onError.message,
                                    desc: onError.code,
                                    buttons: [
                                      DialogButton(
                                        color: primary,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Cancelar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Hero'),
                                        ),
                                      )
                                    ]).show();
                              });
                            }
                          },
                        ),
                      ),
                      Divider(
                        endIndent: 1,
                        indent: 1,
                        height: 10,
                      ),
                      Column(
                        children: <Widget>[
                          Text('Social Login'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                color: Colors.red,
                                onPressed: () {},
                                icon: Icon(FontAwesomeIcons.google),
                              ),
                            ],
                          )
                        ],
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
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => page));
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   
      return _loginPage();
    

    
  }
}
