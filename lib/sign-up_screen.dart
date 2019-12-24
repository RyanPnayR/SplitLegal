import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:splitlegal/password_form_field.dart';

class SignUpPage extends StatelessWidget {
  final GlobalKey<FormBuilderState> _signUpKey = GlobalKey<FormBuilderState>();
  final TextEditingController _passwordController = TextEditingController();

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
    var theme = Theme.of(context);

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
                          _signUp(context);
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
