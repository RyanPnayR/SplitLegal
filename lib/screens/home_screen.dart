import 'package:flutter/material.dart';
import 'package:splitlegal/dashboard.dart';
import 'package:splitlegal/screens/divorce_form_select.dart';
import 'package:splitlegal/sign-in.dart';
import '../app_state_container.dart';
import '../models/app_state.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  AppState appState;

  Widget get _pageToDisplay {
    if (appState.isLoading) {
      return _loadingView;
    } else if (!appState.isLoading && appState.user == null) {
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
    var completedForms = appState.userData.forms.firstWhere((form) {
      return form.status.compareTo('completed') == 0;
    }, orElse: () => null);
    if (appState.userData.forms.length == 0 || completedForms == null) {
      return new DivorceFormSelect();
    } else {
      return new Dashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
    Widget body = _pageToDisplay;
    Size size = MediaQuery.of(context).size;

    return new Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
          width: size.width,
          child: Theme(
            data: Theme.of(context).copyWith(
              // Set the transparency here
              canvasColor: Colors
                  .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
            ),
            child: new Drawer(),
          )),
      appBar: new AppBar(
        title: Text(
          "SPLIT LEGAL",
          style:
              TextStyle(fontFamily: 'Roboto', fontSize: 14, letterSpacing: 4),
        ),
        elevation: 0,
        leading: new Container(
            child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: FlatButton(
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    padding: EdgeInsets.only(left: 10.0),
                    child: Image.asset('images/split_legal_logo.png')))),
      ),
      body: body,
    );
  }
}
