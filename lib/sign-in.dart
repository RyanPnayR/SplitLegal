import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:splitlegal/sign-up_screen.dart';

class SignInPage extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Future<void> _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        password: _fbKey.currentState.fields['password'].currentState.value,
        email: _fbKey.currentState.fields['email'].currentState.value,
      );
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  @override
  Widget build(BuildContext context) {
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
                autovalidate: true,
                child: Column(children: <Widget>[
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
                    ],
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
                  color: Color.fromRGBO(72, 101, 115, 1),
                  textColor: Colors.white,
                  child: Text("Sign Up"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    var SignUp = new SignUpPage();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp),
                    );
                  },
                ),
                MaterialButton(
                  child: Text("Login"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: Color.fromRGBO(15, 39, 96, 1),
                  textColor: Colors.white,
                  onPressed: () {
                    if (_fbKey.currentState.saveAndValidate()) {
                      _signIn();
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
              onPressed: () {},
              darkMode: false, // default: false
            )
          ],
        ),
      ],
    ));
  }
}
