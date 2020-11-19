import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'models/app_state.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

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
  final FirebaseFirestore store = FirebaseFirestore.instance;
  String initialRoute = '/';
  bool appInitialized = false;
  final FirebaseStorage storage = FirebaseStorage(
      app: Firebase.app(), storageBucket: 'gs://splitlegal.appspot.com');
  var uuid = Uuid();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    setState(() {
      googleUser = null;
      state.user = null;
    });
  }

  Future<void> signIn(email, password) async {
    UserCredential creds = await _auth.signInWithEmailAndPassword(
      password: password,
      email: email.trim(),
    );
    setState(() {
      state.user = creds.user;
    });
    await setUpUserData();
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

    appInitialized = true;
  }

  Future initUser() async {
    googleUser = await _ensureLoggedInOnStartUp();
    if (googleUser == null) {
      setAppLoading(false);
    } else {
      setState(() {
        initialRoute = '/home';
      });
      var firebaseUser = await logIntoFirebase();
    }
  }

  setUpUserData() async {
    DocumentReference userRef = store.collection('users').doc(state.user.uid);
    DocumentSnapshot userDoc = await userRef.get();
    setState(() {
      state.userData = UserData.fromJson(userDoc.data());
    });

    List<UserFilingRequest> requests = await getUserFilingRequests();
    List<Activity> activities = await getUserActivities();
    setState(() {
      state.userData.requests = requests;
      state.currentRequest = requests[0];
      state.currentRequest.tasks = activities;
      state.currentRequest.milestones = [
        MilestoneTransition(
            fromMilestone: '', toMilestone: 'First Meeting', completed: true),
        MilestoneTransition(
            fromMilestone: 'First Meeting',
            toMilestone: 'Filled out documents'),
        MilestoneTransition(
            fromMilestone: 'Filled out documents',
            toMilestone: 'Final Meeting'),
      ];
    });
  }

  Stream<QuerySnapshot> getForms() {
    return store.collection('forms').snapshots();
  }

  Stream<QuerySnapshot> getUserForms(user) {
    DocumentReference userRef = store.collection('users').doc(user.uid);
    return userRef.collection('forms').snapshots();
  }

  setAppLoading([bool isLoading = true]) {
    setState(() {
      state.isLoading = isLoading;
    });
  }

  Future<void> logIntoFirebase() async {
    if (googleUser == null) {
      try {
        googleUser = await googleSignIn.signIn();
      } catch (error) {
        print(error);
        return null;
      }
    }

    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      auth.User user = await signIntoFirebase(account);
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

  Future<auth.User> signIntoFirebase(
      GoogleSignInAccount googleSignInAccount) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;
    print(googleAuth.accessToken);
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential creds = await _auth.signInWithCredential(credential);
    return creds.user;
  }

  Future<void> signUp(FormBuilderState signUpFormState) async {
    return _auth
        .createUserWithEmailAndPassword(
            email: signUpFormState.fields['email'].currentState.value,
            password: signUpFormState.fields['password'].currentState.value)
        .then((res) async {
      setState(() {
        state.user = res.user;
      });
      store.collection('users').doc(res.user.uid).set({
        'first_name': signUpFormState.fields['first_name'].currentState.value,
        'last_name': signUpFormState.fields['last_name'].currentState.value,
        'foroms': signUpFormState.fields['last_name'].currentState.value,
      });
    });
  }

  Future<void> completeForm(String formId) async {
    DocumentReference userRef = store.collection('users').doc(state.user.uid);
    await userRef
        .collection('forms')
        .doc(formId)
        .update({'status': 'processing', 'updated_at': new DateTime.now()});
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0),
      ),
    );
  }

  Future<List<UserFilingRequest>> getUserFilingRequests() async {
    QuerySnapshot requests = await store
        .collection('requests')
        .where("userId", isEqualTo: state.user.uid)
        .get();

    return requests.docs
        .map((req) => UserFilingRequest.fromJson(req.data()))
        .toList();
  }

  Future<List<Activity>> getUserActivities() async {
    QuerySnapshot activities = await store
        .collection('activities')
        .where("userId", isEqualTo: state.user.uid)
        .get();

    return activities.docs.map((act) {
      Map<String, dynamic> actData = act.data();
      actData.addAll({"id": act.id});
      return Activity.fromJson(actData);
    }).toList();
  }

  Future<void> updateActivity(Activity task) async {
    try {
      await store.collection('activities').doc(task.id).update(task.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> addUserFilingRequests(UserFilingRequest request) async {
    await store.collection('requests').add(request.toJson());
  }

  Future<void> createUserFilingRequest(UserFilingRequest request) async {
    await store.collection('requests').add(request.toJson());
  }

  Future<File> getFileFromUrl(String url) async {
    var dir = await getApplicationDocumentsDirectory();
    String filePath = '${dir.path}/${url}.pdf';

    if (await File(filePath).exists()) {
      return File(filePath);
    } else {
      try {
        var downloadUrl = await storage
            .ref()
            .child('users')
            .child(state.user.uid)
            .child('forms')
            .child(url + '.pdf')
            .getDownloadURL();
        var data = await http.get(downloadUrl);
        var bytes = data.bodyBytes;
        File file = File("$filePath");

        File urlFile = await file.writeAsBytes(bytes);
        return urlFile;
      } catch (e) {
        throw Exception("Error opening url file");
      }
    }
  }

  Future<String> uploadDocument(File file, String folderName) async {
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(state.user.uid)
        .child(folderName)
        .child(basename(file.path));
    TaskSnapshot uploadTask = await firebaseStorageRef.putFile(file);
    return uploadTask.ref.getDownloadURL();
  }

  Future<List<String>> uploadDocuments(
      List<PlatformFile> docs, String folderName) async {
    List<String> fileUrls = [];
    for (PlatformFile doc in docs) {
      String downloadUrl = await uploadDocument(File(doc.path), folderName);
      fileUrls.add(downloadUrl);
    }
    return fileUrls;
  }

  Future<String> getUsersForm(String formId) async {
    File file = await getFileFromUrl(formId);
    return file.path;
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
      [List<Widget> displayText,
      List<Widget> actions,
      bool barrierDismissable = false]) {
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
        barrierDismissible: barrierDismissable,
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
