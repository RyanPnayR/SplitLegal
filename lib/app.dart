import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:splitlegal/dashboard.dart';
import 'package:splitlegal/screens/home_screen.dart';
import 'package:splitlegal/screens/survey_monkey.dart';
import 'package:splitlegal/sign-in.dart';
import 'package:splitlegal/sign-up_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:splitlegal/models/app_state.dart';

class AppRootWidget extends StatefulWidget {
  @override
  AppRootWidgetState createState() => new AppRootWidgetState();
}

class FormRouteArguments {
  // final SplitLegalForm form;
  final String userFormId;

  FormRouteArguments(this.userFormId);
}

class AppRootWidgetState extends State<AppRootWidget> {
  String initialRoute;

  ThemeData get _themeData => new ThemeData(
      fontFamily: 'Roboto',
      primaryColor: Color.fromRGBO(64, 64, 64, 1),
      secondaryHeaderColor: Color.fromRGBO(15, 39, 96, 1),
      hoverColor: Color.fromRGBO(100, 108, 110, 1),
      buttonColor: Color.fromRGBO(72, 101, 115, 1),
      hintColor: Colors.white.withOpacity(0.5),
      bottomAppBarColor: Color.fromRGBO(24, 253, 225, 1),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, .75)),
      ),
      textTheme: TextTheme(
          display1:
              TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1)));

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
              '/settings': (BuildContext context) {
                return Scaffold(
                  body: Column(
                    children: <Widget>[Text('Settings')],
                  ),
                );
              },
              '/survey': (BuildContext context) {
                final FormRouteArguments args =
                    ModalRoute.of(context).settings.arguments;
                return new WillPopScope(
                  onWillPop: () {
                    return _onWillPop(context);
                  },
                  child: new WebviewScaffold(
                    url: '?form_id=' + args.userFormId,
                    javascriptChannels: [
                      new JavascriptChannel(
                          name: 'SplitLegal',
                          onMessageReceived: (res) async {
                            var container = AppStateContainer.of(context);
                            await container.completeForm(args.userFormId);
                            await container.setUpUserData();
                            Navigator.of(context).pop();
                          })
                    ].toSet(),
                  ),
                );
              },
            },
          );
  }
}
