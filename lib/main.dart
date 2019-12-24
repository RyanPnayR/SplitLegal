import 'package:flutter/material.dart';
import 'package:splitlegal/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(64, 64, 64, 1),
        secondaryHeaderColor: Color.fromRGBO(15, 39, 96, 1),
        buttonColor: Color.fromRGBO(72, 101, 115, 1),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, .5)),
        ),
        textTheme: TextTheme(
          display1: TextStyle(color: Colors.white, fontSize: 16)
        )
      ),
      home: HomePage(),
    );
  }
}