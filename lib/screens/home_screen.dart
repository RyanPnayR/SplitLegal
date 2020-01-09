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

  Widget getSidebarLink(BuildContext context, String title, String route) {
    return Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2.0, color: Colors.white)),
        ),
        width: 250,
        margin: EdgeInsets.only(left: 20.0, bottom: 20),
        child: FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.popUntil(context, (currentRoute) {
                if (currentRoute.settings.name != route) {
                  Navigator.of(context).pushNamed(route);
                }
                return true;
              });
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
            child: new Drawer(
              child: ListView(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
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
                              getSidebarLink(context, 'Documents', '/'),
                              getSidebarLink(context, 'Settings', '/settings'),
                              Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 2.0, color: Colors.white)),
                                  ),
                                  width: 250,
                                  margin:
                                      EdgeInsets.only(left: 20.0, bottom: 20),
                                  child: FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                                context, '/auth')
                                            .then((res) {
                                          setState(() {
                                            container.state.user = null;
                                            container.googleUser = null;
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
                                          ))))
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
