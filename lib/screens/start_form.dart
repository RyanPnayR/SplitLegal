import 'package:flutter/material.dart';
import 'package:splitlegal/dashboard.dart';
import 'package:splitlegal/sign-in.dart';
import '../app_state_container.dart';
import '../models/app_state.dart';
import 'divorce_form_select.dart';

class StartScreen extends StatefulWidget {
  @override
  StartScreenState createState() => new StartScreenState();
}

class StartScreenState extends State<StartScreen> {
  AppState appState;

  Widget get _pageToDisplay {
    if (!appState.isLoading && appState.user == null) {
      return new SignInPage();
    } else {
      return _homeView;
    }
  }

  Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget get _homeView {
    return new DivorceFormSelect();
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
    Widget body = _pageToDisplay;

    return new Scaffold(
      body: body,
    );
  }
}
