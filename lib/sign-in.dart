import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_sign_in/google_sign_in.dart' as prefix0;
import 'package:splitlegal/app_state_container.dart';
import 'package:splitlegal/password_form_field.dart';
import 'package:splitlegal/sign-up_screen.dart';

class SignInPage extends StatefulWidget {
  @override
  SignInPageState createState() {
    return new SignInPageState();
  }
}

class SignInPageState extends State<SignInPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final container = AppStateContainer.of(context);

    return Scaffold(
        body: ListView(
      children: <Widget>[
        SizedBox(
          child: Hero(
            tag: 'Sign in page',
            child: Image.asset('images/split-legal-logo-signin.png'),
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              width: 300,
              child: FormBuilder(
                key: _fbKey,
                initialValue: {
                  'date': DateTime.now(),
                  'accept_terms': false,
                },
                child: Column(children: <Widget>[
                  FormBuilderTextField(
                    attribute: "email",
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, .5)),
                    ),
                    validators: [
                      FormBuilderValidators.email(),
                      FormBuilderValidators.required(),
                    ],
                  ),
                  PasswordFormField(
                    attribute: 'password',
                    labelText: 'Password',
                    style: TextStyle(color: Colors.black),
                    labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, .5)),
                    validators: [],
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  color: Theme.of(context).buttonColor,
                  textColor: Colors.white,
                  child: Text("Sign Up"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    var SignUp = new SignUpPage();
                    Navigator.pushReplacementNamed(context, '/signUp');
                  },
                ),
                MaterialButton(
                  child: Text("Login"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: Theme.of(context).secondaryHeaderColor,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_fbKey.currentState.saveAndValidate()) {
                      container.showLoadingDialog(context);
                      container
                          .signIn(
                              _fbKey.currentState.fields['email'].currentState
                                  .value,
                              _fbKey.currentState.fields['password']
                                  .currentState.value)
                          .then((res) async {
                        container.hideDialog(context);
                        Navigator.pushReplacementNamed(context, '/home');
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
            SizedBox(
              height: 30,
            ),
            Text('or'),
            SizedBox(
              height: 30,
            ),
            GoogleSignInButton(
              onPressed: () {
                container.logIntoFirebase().then((res) {
                  Navigator.pushReplacementNamed(context, '/home');
                });
              },
              darkMode: false, // default: false
            )
          ],
        ),
      ],
    ));
  }

  static GoogleSignIn() {}
}
