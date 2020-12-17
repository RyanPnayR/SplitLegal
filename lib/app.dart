import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:splitlegal/screens/home_screen.dart';
import 'package:splitlegal/sign-in.dart';
import 'package:splitlegal/sign-up_screen.dart';

class AppRootWidget extends StatefulWidget {
  @override
  AppRootWidgetState createState() => new AppRootWidgetState();
}

class FormRouteArguments {
  // final SplitLegalForm form;
  final String uri;
  FormRouteArguments(this.uri);
}

class AppRootWidgetState extends State<AppRootWidget> {
  String initialRoute;

  ThemeData get _themeData => new ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
        primaryColor: Color.fromRGBO(64, 64, 64, 1),
        secondaryHeaderColor: Color.fromRGBO(15, 39, 96, 1.0),
        hoverColor: Color.fromRGBO(100, 108, 110, 1),
        buttonColor: Color.fromRGBO(72, 101, 115, 1),
        hintColor: Colors.white.withOpacity(0.5),
        bottomAppBarColor: Color.fromRGBO(24, 253, 225, 1),
        accentColor: Color.fromRGBO(24, 253, 225, 1),
        unselectedWidgetColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, .75)),
        ),
        textTheme: TextTheme(
          display1: TextStyle(
            color: Colors.white,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
      );

  Future<bool> _onWillPop(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    return !container.appInitialized
        ? new Center(
            child: new CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(255, 255, 255, 0),
            ),
          )
        : new MaterialApp(
            title: 'Inherited',
            theme: _themeData,
            initialRoute: container.initialRoute,
            routes: {
              '/': (BuildContext context) => new SignInPage(),
              '/home': (BuildContext context) => new HomeScreen(),
              '/signUp': (BuildContext context) => new SignUpPage(),
              '/doc': (BuildContext context) =>
                  new WebviewScaffold(url: container.state.docusignUrl),
              '/settings': (BuildContext context) {
                return Scaffold(
                  body: Column(
                    children: <Widget>[Text('Settings')],
                  ),
                );
              }
            },
          );
  }
}
