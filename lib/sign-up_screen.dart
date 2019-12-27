import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:splitlegal/password_form_field.dart';

import 'app_state_container.dart';
import 'models/app_state.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() {
    return new SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormBuilderState> _signUpKey = GlobalKey<FormBuilderState>();
  AppState appState;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var container = AppStateContainer.of(context);
    appState = container.state;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your Account'),
        elevation: 0.0,
        backgroundColor: theme.primaryColor,
      ),
      backgroundColor: theme.primaryColor,
      persistentFooterButtons: <Widget>[
        SizedBox(
            width: 350,
            height: 90,
            child: Column(
              children: <Widget>[
                Text(
                  'By creating an account you accept Split Legal’s Terms of Service and Privacy Policy',
                  style: theme.textTheme.display1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 100,
                      child: Text("Sign up"),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      color: Theme.of(context).secondaryHeaderColor,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_signUpKey.currentState.saveAndValidate()) {
                          container.signUp(_signUpKey.currentState);
                          Navigator.pushNamed(context, '/');
                        }
                      },
                    ),
                  ],
                ),
              ],
            )),
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
              child: Column(children: <Widget>[
                FormBuilderTextField(
                  attribute: "first_name",
                  style: theme.textTheme.display1,
                  decoration: InputDecoration(
                      labelText: "First Name",
                      labelStyle: theme.inputDecorationTheme.labelStyle),
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                ),
                FormBuilderTextField(
                  attribute: "last_name",
                  style: theme.textTheme.display1,
                  decoration: InputDecoration(
                      labelText: "Last Name",
                      labelStyle: theme.inputDecorationTheme.labelStyle),
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                ),
                FormBuilderTextField(
                  attribute: "email",
                  style: theme.textTheme.display1,
                  decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: theme.inputDecorationTheme.labelStyle),
                  validators: [
                    FormBuilderValidators.email(),
                    FormBuilderValidators.required(),
                  ],
                ),
                PasswordFormField(
                  attribute: 'password',
                  labelText: 'Password',
                  validators: [
                    (val) {
                      if (val.toLowerCase() !=
                          _signUpKey.currentState.fields['repeat_password']
                              .currentState.value) {
                        return "Passwords should match";
                      }
                    },
                  ],
                ),
                PasswordFormField(
                  attribute: 'repeat_password',
                  labelText: 'Repeat Password',
                  validators: [
                    (val) {
                      if (val.toLowerCase() !=
                          _signUpKey.currentState.fields['password']
                              .currentState.value) {
                        return "Passwords should match";
                      }
                    },
                  ],
                )
              ]),
            ),
          ),
        ])
      ]),
    );
  }
}
