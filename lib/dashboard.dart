import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dashboard extends StatelessWidget {
  static const platform =
      const MethodChannel('com.Rahim.myFlutterApp/surveyMonkey');
  static String sessionSurveyMonkeyHash = 'TB2927J';

  Future _loadSurveyMonkey() async {
    try {
      await platform
          .invokeMethod('surveyMonkey', sessionSurveyMonkeyHash)
          .then((result) {
        Fluttertoast.showToast(
            msg: result,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: RaisedButton(
          onPressed: _loadSurveyMonkey,
          child: Text("Load SurveyMonkey"),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
