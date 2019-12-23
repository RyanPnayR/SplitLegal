import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignUpPage extends StatelessWidget {
  final GlobalKey<FormBuilderState> _signUpKey = GlobalKey<FormBuilderState>();

  Future<void> _signUp(context) async {
    try {
      print('hellow');
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _signUpKey.currentState.fields['email'].currentState.value,
              password:
                  _signUpKey.currentState.fields['password'].currentState.value)
          .then((res) async {
        Navigator.pop(context);
      });
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your Account'),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(64, 64, 64, 1),
      ),
      backgroundColor: Color.fromRGBO(64, 64, 64, 1),
      persistentFooterButtons: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MaterialButton(
              child: Text("Sign up"),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              color: Color.fromRGBO(15, 39, 96, 1),
              textColor: Colors.white,
              onPressed: () {
                if (_signUpKey.currentState.saveAndValidate()) {
                  _signUp(context);
                }
              },
            ),
          ],
        ),
      ],
      body: ListView(children: <Widget>[
        Column(children: <Widget>[
          SizedBox(
            width: 300,
            child: FormBuilder(
              key: _signUpKey,
              initialValue: {
                'date': DateTime.now(),
                'accept_terms': false,
              },
              autovalidate: true,
              child: Column(children: <Widget>[
                FormBuilderTextField(
                  attribute: "first_name",
                  decoration: InputDecoration(labelText: "First Name"),
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                ),
                FormBuilderTextField(
                  attribute: "last_name",
                  decoration: InputDecoration(labelText: "Last Name"),
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                ),
                FormBuilderTextField(
                  attribute: "email",
                  decoration: InputDecoration(labelText: "Email"),
                  validators: [
                    FormBuilderValidators.email(),
                    FormBuilderValidators.required(),
                  ],
                ),
                FormBuilderTextField(
                  attribute: "password",
                  decoration: InputDecoration(labelText: "Password"),
                  validators: [
                    FormBuilderValidators.minLength(8),
                    FormBuilderValidators.required(),
                    (val) {
                      if (val.toLowerCase() !=
                          _signUpKey.currentState.fields['repeat_password']
                              .currentState.value) {
                        return "Passwords should match";
                      }
                    },
                  ],
                ),
                FormBuilderTextField(
                  attribute: "repeat_password",
                  decoration: InputDecoration(labelText: "Repeat Password"),
                  validators: [
                    FormBuilderValidators.minLength(8),
                    FormBuilderValidators.required(),
                    (val) {
                      if (val.toLowerCase() !=
                          _signUpKey.currentState.fields['password']
                              .currentState.value) {
                        return "Passwords should match";
                      }
                    },
                  ],
                ),
              ]),
            ),
          ),
        ])
      ]),
    );
  }
}
