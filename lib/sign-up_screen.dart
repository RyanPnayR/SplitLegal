import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:splitlegal/password_form_field.dart';
import 'package:splitlegal/screens/home_screen.dart';

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

  InputDecoration getFieldDecoration(String fieldName) {
    var theme = Theme.of(context);

    return InputDecoration(
        labelText: fieldName,
        labelStyle: theme.inputDecorationTheme.labelStyle,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var container = AppStateContainer.of(context);
    appState = container.state;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your Account'),
        elevation: 0.0,
        backgroundColor: theme.secondaryHeaderColor,
      ),
      backgroundColor: theme.primaryColor,
      persistentFooterButtons: <Widget>[
        Container(
          margin: new EdgeInsets.only(top: 25),
          child: SizedBox(
              width: 350,
              height: 125,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: new EdgeInsets.only(bottom: 20, right: 25),
                    child: Text(
                      'By creating an account you accept Split Legal’s Terms of Service and Privacy Policy',
                      style: theme.textTheme.display1,
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.only(right: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                          minWidth: 150,
                          child: Text("Sign up"),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                          ),
                          color: Theme.of(context).secondaryHeaderColor,
                          textColor: Colors.white,
                          onPressed: () {
                            if (_signUpKey.currentState.saveAndValidate()) {
                              container.showLoadingDialog(context);
                              container
                                  .signUp(_signUpKey.currentState)
                                  .then((res) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                  (Route<dynamic> route) => false,
                                );
                              }).catchError((e) {
                                container.hideDialog(context);
                                container.showErrorDialog(context, [
                                  Text(
                                    'Uh, oh!',
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                  Text(e.message)
                                ]);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ],
      body: ListView(children: <Widget>[
        Container(
            padding: new EdgeInsets.only(bottom: 100),
            color: theme.secondaryHeaderColor,
            child: Column(children: <Widget>[
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
                      decoration: getFieldDecoration("First Name"),
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: "last_name",
                      style: theme.textTheme.display1,
                      decoration: getFieldDecoration("Last Name"),
                      validators: [
                        FormBuilderValidators.required(),
                      ],
                    ),
                    FormBuilderTextField(
                      attribute: "email",
                      style: theme.textTheme.display1,
                      decoration: getFieldDecoration("Email"),
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
            ]))
      ]),
    );
  }
}
