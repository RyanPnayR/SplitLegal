import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'models/app_state.dart';

class AppStateContainer extends StatefulWidget {
  final AppState state;
  final Widget child;

  AppStateContainer({
    @required this.child,
    this.state,
  });

  // This creates a method on the AppState that's just like 'of'
  // On MediaQueries, Theme, etc
  // This is the secret to accessing your AppState all over your app
  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  _AppStateContainerState createState() => new _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  AppState state;
  GoogleSignInAccount googleUser;
  final googleSignIn = new GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore store = Firestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  void signOutGoogle() {
    _googleSignIn.signOut();
    googleUser = null;
    setState(() {
      state.user = null;
    });
    print("User Sign Out");
  }

  Future<void> signIn(email, password) async {
    setState(() {
      state.isLoading = true;
    });
    try {
      FirebaseUser user = await _auth.signInWithEmailAndPassword(
        password: password,
        email: email,
      );
      setState(() {
        state.isLoading = false;
        state.user = user;
      });
    } catch (e) {
      setState(() {
        state.isLoading = false;
      });
      print(e); // TODO: show dialog with error
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new AppState.loading();
      initUser();
    }
  }

  Future initUser() async {
    googleUser = await _ensureLoggedInOnStartUp();
    if (googleUser == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      var firebaseUser = await logIntoFirebase();
    }
  }

  setAppLoading([bool isLoading = true]) {
    print(isLoading);
    setState(() {
      state.isLoading = true;
    });
  }

  logIntoFirebase() async {
    if (googleUser == null) {
      googleUser = await googleSignIn.signIn();
    }

    FirebaseUser firebaseUser;
    FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ]);
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      FirebaseUser user = await signIntoFirebase(account);
      setState(() {
        state.isLoading = false;
        state.user = user;
      });
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<dynamic> _ensureLoggedInOnStartUp() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) {
      user = await googleSignIn.signInSilently();
    }
    googleUser = user;
    return user;
  }

  Future<FirebaseUser> signIntoFirebase(
      GoogleSignInAccount googleSignInAccount) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;
    print(googleAuth.accessToken);
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<void> signUp(FormBuilderState signUpFormState) async {
    setAppLoading();
    try {
      _auth
          .createUserWithEmailAndPassword(
              email: signUpFormState.fields['email'].currentState.value,
              password: signUpFormState.fields['password'].currentState.value)
          .then((res) async {
        setState(() {
          state.user = res;
        });
        store.collection('users').document(res.uid).setData({
          'first_name': signUpFormState.fields['first_name'].currentState.value,
          'last_name': signUpFormState.fields['last_name'].currentState.value,
        });
        setAppLoading(false);
      });
    } catch (e) {
      print(e); // TODO: show dialog with error
      Navigator.pushNamed(context, '/signUp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _AppStateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
