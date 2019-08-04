import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:welearn/providers/provider.dart';
import 'package:welearn/screens/initial.dart';
import 'package:welearn/styles/styles.dart';

class ProfileSet extends StatefulWidget {
  @override
  _ProfileSetState createState() => _ProfileSetState();
}

class _ProfileSetState extends State<ProfileSet> {
  final GlobalKey<FormBuilderState> _profile = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        brightness: Brightness.light,
        title: Text(
          'Cuentanos de ti',
          style: TextStyle(
              fontFamily: 'hero',
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text('Guardar'),
          icon: Icon(FontAwesomeIcons.upload),
          onPressed: () {
            _profile.currentState.save();
            if (_profile.currentState.validate()) {
              print(_profile.currentState.value);
              Map<String, dynamic> usuario = new Map<String, dynamic>();
              usuario["age"] = _profile.currentState.value["age"];
              usuario["country"] = _profile.currentState.value["country"];

              usuario["name"] = _profile.currentState.value["name"];
              usuario["role"] = "ROLE_USER";
              usuario["user_id"] = mainProvider.currentUser.uid;

              usuario["surname"] = _profile.currentState.value["surname"];
              usuario["picture"] =
                  "https://firebasestorage.googleapis.com/v0/b/welearn-4b24d.appspot.com/o/nninja.png?alt=media&token=490f90b0-30e4-4cd8-956a-b241fce88d2d";

              DocumentReference usuarios =
                  Firestore.instance.collection("users").document();

              Firestore.instance.runTransaction((transaction) async {
                await transaction.set(usuarios, usuario).then((v) {
                  print("instance created");
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => RootPage()));
                });
              });
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .5,
                height: MediaQuery.of(context).size.width * .5,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('assets/icon.png'))),
              ),
              FormBuilder(
                key: _profile,
                autovalidate: false,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        attribute: "name",
                        decoration: InputDecoration(
                            prefixStyle: TextStyle(color: primary),
                            labelStyle: TextStyle(
                                color: Colors.black, fontFamily: 'hero'),
                            labelText: "Nombre",
                            prefixIcon: Icon(Icons.people_outline)),
                        validators: [
                          FormBuilderValidators.minLength(3),
                          FormBuilderValidators.required()
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        attribute: "surname",
                        decoration: InputDecoration(
                            prefixStyle: TextStyle(color: primary),
                            labelStyle: TextStyle(
                                color: Colors.black, fontFamily: 'hero'),
                            labelText: "Apellidos",
                            prefixIcon: Icon(Icons.people_outline)),
                        validators: [
                          FormBuilderValidators.minLength(3),
                          FormBuilderValidators.required()
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        attribute: "country",
                        decoration: InputDecoration(
                            prefixStyle: TextStyle(color: primary),
                            labelStyle: TextStyle(
                                color: Colors.black, fontFamily: 'hero'),
                            labelText: "Pais",
                            prefixIcon: Icon(FontAwesomeIcons.globeAmericas)),
                        validators: [
                          FormBuilderValidators.minLength(3),
                          FormBuilderValidators.required()
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderTextField(
                        attribute: "age",
                        decoration: InputDecoration(
                            prefixStyle: TextStyle(color: primary),
                            labelStyle: TextStyle(
                                color: Colors.black, fontFamily: 'hero'),
                            labelText: "Edad",
                            prefixIcon: Icon(FontAwesomeIcons.birthdayCake)),
                        validators: [
                          FormBuilderValidators.maxLength(2),
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.required()
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
