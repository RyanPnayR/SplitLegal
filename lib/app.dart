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
  final SplitLegalForm form;
  final String userFormId;
  FormRouteArguments(this.form, this.userFormId);
}

class AppRootWidgetState extends State<AppRootWidget> {
  ThemeData get _themeData => new ThemeData(
      fontFamily: 'Roboto',
      primaryColor: Color.fromRGBO(64, 64, 64, 1),
      secondaryHeaderColor: Color.fromRGBO(15, 39, 96, 1),
      hoverColor: Color.fromRGBO(100, 108, 110, 1),
      buttonColor: Color.fromRGBO(72, 101, 115, 1),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, .5)),
      ),
      textTheme:
          TextTheme(display1: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1)));

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Inherited',
      theme: _themeData,
      routes: {
        '/': (BuildContext context) => new HomeScreen(),
        '/auth': (BuildContext context) => new SignInPage(),
        '/signUp': (BuildContext context) => new SignUpPage(),
        '/survey': (BuildContext context) {
          final FormRouteArguments args =
              ModalRoute.of(context).settings.arguments;
          return new WillPopScope(
            onWillPop: () async => false,
            child: new WebviewScaffold(
              url: args.form.formUrl + '?form_id=' + args.userFormId,
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
