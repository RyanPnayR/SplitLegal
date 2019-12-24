import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:splitlegal/dashboard.dart';
import 'package:splitlegal/sign-in.dart';

final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomePageState();

}

class HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }
          return Dashboard();
        } else {
          return Scaffold(
            body: Center(
              child: SpinKitFadingGrid(
                color: Colors.black,
              ),
            ),
          );
        }
      },
    );
  }
}
