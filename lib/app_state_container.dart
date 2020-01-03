import 'dart:async';
import 'package:flutter/services.dart';
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
  }

  Future<void> signIn(email, password) async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
      password: password,
      email: email.trim(),
    );
    setState(() {
      state.user = user;
    });
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
      setAppLoading(false);
    } else {
      var firebaseUser = await logIntoFirebase();
    }
  }

  setUpUserData() async {
    DocumentSnapshot userDoc =
        await store.collection('users').document(state.user.uid).get();
    setState(() {
      state.userData = UserData.fromMap(userDoc.data);
    });
  }

  Stream<QuerySnapshot> getForms() {
    return store.collection('forms').snapshots();
  }

  setAppLoading([bool isLoading = true]) {
    setState(() {
      state.isLoading = isLoading;
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
        state.user = user;
      });
      await setUpUserData();
      setAppLoading(false);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<dynamic> _ensureLoggedInOnStartUp() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    try {
      if (user == null) {
        user = await googleSignIn.signInSilently(suppressErrors: true);
      }
    } catch (e) {
      user = null;
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
    return _auth
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
    });
  }

  Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0),
      ),
    );
  }

  Future<void> showLoadingDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          content: _loadingView,
          backgroundColor: Color.fromRGBO(255, 255, 255, 0),
        );
      },
    );
  }

  Future<void> showErrorDialog(BuildContext context,
      [List<Widget> displayText, List<Widget> actions]) {
    displayText =
        displayText != null ? displayText : [Text('An error has occurred.')];
    actions = actions != null
        ? actions
        : [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ];
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: displayText,
                ),
              ),
              actions: actions);
        });
  }

  void hideDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
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