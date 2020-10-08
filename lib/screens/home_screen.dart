import 'package:flutter/material.dart';
import 'package:splitlegal/dashboard.dart';
import 'package:splitlegal/models/app_state.dart';
import 'package:splitlegal/screens/divorce_form_select.dart';
import 'package:splitlegal/screens/settings_screen.dart';

import '../app_state_container.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => new HomeScreenState();
}

enum homeScreenPages { documents, settings }

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppState appState;
  homeScreenPages currentPage = homeScreenPages.documents;

  Widget get _pageToDisplay {
    if (appState.isLoading) {
      return _loadingView;
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
    var completedForms = null;
    if (completedForms == null) {
      return new DivorceFormSelect();
    } else {
      switch (currentPage) {
        case homeScreenPages.settings:
          return new Settings();
          break;
        default:
          return new Dashboard();
      }
    }
  }

  Widget get _appbar {
    return new AppBar(
      title: Text(
        "SPLIT LEGAL",
        style: TextStyle(fontFamily: 'Roboto', fontSize: 14, letterSpacing: 4),
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
    );
  }

  Widget getSidebarLink(
      BuildContext context, String title, homeScreenPages page) {
    return Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2.0, color: Colors.white)),
        ),
        width: 250,
        margin: EdgeInsets.only(left: 20.0, bottom: 20),
        child: FlatButton(
            onPressed: () {
              setState(() {
                currentPage = page;
              });
              Navigator.of(context).pop();
            },
            child: SizedBox(
                width: double.infinity,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.start,
                ))));
  }

  Widget getLogout(BuildContext context) {
    var container = AppStateContainer.of(context);
    return Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2.0, color: Colors.white)),
        ),
        width: 250,
        margin: EdgeInsets.only(left: 20.0, bottom: 20),
        child: FlatButton(
            onPressed: () async {
              await Navigator.pop(context);
              container.showLoadingDialog(context);
              Navigator.pushReplacementNamed(context, '/').then((res) {
                container.signOutGoogle().then((res) {
                  container.hideDialog(context);
                });
              });
            },
            child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.start,
                ))));
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
    Widget body = _pageToDisplay;
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    return new Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
          width: size.width * 0.75,
          child: Theme(
            data: theme.copyWith(
                // Set the transparency here
                canvasColor: theme
                    .secondaryHeaderColor //or any other color you want. e.g Colors.blue.withOpacity(0.5)
                ),
            child: new Drawer(
              child: ListView(
                children: <Widget>[
                  AppBar(
                    backgroundColor:
                        theme.secondaryHeaderColor.withOpacity(0.5),
                    title: Text(
                      "SPLIT LEGAL",
                      style: TextStyle(
                          fontFamily: 'Roboto', fontSize: 14, letterSpacing: 4),
                    ),
                    elevation: 0,
                    leading: new Container(
                        child: ConstrainedBox(
                            constraints: BoxConstraints.expand(),
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                padding: EdgeInsets.only(left: 10.0),
                                child: Image.asset(
                                    'images/split_legal_logo.png')))),
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 500,
                            width: 2,
                            color: Colors.white,
                            margin: const EdgeInsets.only(left: 55.0, top: 40),
                          )
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 250),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              getSidebarLink(context, 'Documents',
                                  homeScreenPages.documents),
                              getSidebarLink(context, 'Settings',
                                  homeScreenPages.settings),
                              getLogout(context)
                            ],
                          ))
                    ],
                  )
                ],
              ),
            ),
          )),
      appBar: _appbar,
      body: body,
    );
  }
}
