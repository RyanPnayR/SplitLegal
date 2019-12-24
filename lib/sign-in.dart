import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_sign_in/google_sign_in.dart' as prefix0;
import 'package:splitlegal/password_form_field.dart';
import 'package:splitlegal/sign-up_screen.dart';

class SignInPage extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final prefix0.GoogleSignIn _googleSignIn = prefix0.GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  Future<String> signInWithGoogle() async {
    final prefix0.GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final prefix0.GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    _googleSignIn.signOut();

    print("User Sign Out");
  }

  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
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
                  color: Theme.of(context).secondaryHeaderColor,
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
              onPressed: () {
                signInWithGoogle();
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
