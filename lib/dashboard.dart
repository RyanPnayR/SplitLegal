import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splitlegal/app_state_container.dart';

class Dashboard extends StatelessWidget {
  static const platform =
      const MethodChannel('com.Rahim.myFlutterApp/surveyMonkey');
  static String sessionSurveyMonkeyHash = 'TB2927J';

  Future _loadSurveyMonkey() async {
    // try {
    //   await platform
    //       .invokeMethod('surveyMonkey', sessionSurveyMonkeyHash)
    //       .then((result) {
    //     Fluttertoast.showToast(
    //         msg: result,
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.CENTER,
    //         timeInSecForIos: 1,
    //         backgroundColor: Colors.red,
    //         textColor: Colors.white,
    //         fontSize: 16.0);
    //   });
    // } on PlatformException catch (e) {
    //   print(e.message);
    // }

  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

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
            onPressed: container.signOutGoogle,
          ),
        ],
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/survey');
          },
          child: Text("Load SurveyMonkey"),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
