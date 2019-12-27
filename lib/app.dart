import 'package:flutter/material.dart';
import 'package:splitlegal/dashboard.dart';
import 'package:splitlegal/screens/home_screen.dart';
import 'package:splitlegal/sign-in.dart';
import 'package:splitlegal/sign-up_screen.dart';

class AppRootWidget extends StatefulWidget {
  @override
  AppRootWidgetState createState() => new AppRootWidgetState();
}

class AppRootWidgetState extends State<AppRootWidget> {
  ThemeData get _themeData => new ThemeData(
      primaryColor: Color.fromRGBO(64, 64, 64, 1),
      secondaryHeaderColor: Color.fromRGBO(15, 39, 96, 1),
      buttonColor: Color.fromRGBO(72, 101, 115, 1),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, .5)),
      ),
      textTheme:
          TextTheme(display1: TextStyle(color: Colors.white, fontSize: 16)));

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Inherited',
      theme: _themeData,
      routes: {
        '/': (BuildContext context) => new HomeScreen(),
        '/auth': (BuildContext context) => new SignInPage(),
        '/signUp': (BuildContext context) => new SignUpPage(),
      },
    );
  }
}
