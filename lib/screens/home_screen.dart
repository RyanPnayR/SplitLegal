import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:splitlegal/dashboard.dart';
import 'package:splitlegal/models/app_state.dart';
import 'package:splitlegal/screens/my_team.dart';
import 'package:splitlegal/screens/overview.dart';
import 'package:splitlegal/screens/settings_screen.dart';
import 'package:splitlegal/screens/start_form.dart';
import 'package:splitlegal/screens/tasks.dart';

import '../app_state_container.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  AppState appState;

  @override
  void initState() {
    flutterWebviewPlugin.onStateChanged.listen((event) {
      var container = AppStateContainer.of(context);

      if (event.url.contains("google.com")) {
        Uri finishedUri = Uri.parse(event.url.toString());
        if (finishedUri.queryParameters["event"] == "signing_complete") {
          appState.selectedTask.status = "pending";
        }
        flutterWebviewPlugin.close();
        setState(() {
          appState.isLoading = true;
          appState.currentPage = homeScreenPages.tasks;
        });

        container.updateActivity(appState.selectedTask).then((value) => {
              container.setUpUserData().then((value) => {
                    setState(() {
                      appState.isLoading = false;
                    })
                  })
            });
      }
    });
  }

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
    if (appState.user != null && appState.userData != null) {
      if (appState.userData.requests != null &&
          appState.userData.requests.isEmpty) {
        return new StartScreen();
      } else {
        switch (appState.currentPage) {
          case homeScreenPages.overview:
            return new Overview();
            break;
          case homeScreenPages.tasks:
            return new Tasks();
            break;
          case homeScreenPages.documents:
            return new Dashboard();
            break;
          case homeScreenPages.team:
            return new MyTeam();
            break;
          case homeScreenPages.settings:
            return new Settings();
            break;
          case homeScreenPages.docusign:
            return new WebviewScaffold(
                url: appState.docusignUrl, appBar: _appbar);
            break;
          default:
            return new Dashboard();
        }
      }
    }
  }

  Widget get _appbar {
    return new AppBar(
      backgroundColor: appState.userData.requests != null &&
              appState.currentPage == homeScreenPages.overview
          ? Theme.of(context).secondaryHeaderColor
          : Theme.of(context).primaryColor,
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
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.white)),
        ),
        width: 200,
        margin: EdgeInsets.only(left: 20.0, bottom: 20),
        child: FlatButton(
            onPressed: () {
              setState(() {
                appState.currentPage = page;
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
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.white)),
        ),
        width: 200,
        margin: EdgeInsets.only(left: 20.0, bottom: 20),
        child: FlatButton(
            onPressed: () async {
              await Navigator.pop(context);
              container.showLoadingDialog(context);
              container.signOutGoogle().then((res) {
                Navigator.pushReplacementNamed(context, '/').then((res) {});
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

  List<Widget> getSidebarItems() {
    List<Widget> items = [
      getSidebarLink(context, 'My Team', homeScreenPages.team),
      getSidebarLink(context, 'Settings', homeScreenPages.settings),
      getLogout(context)
    ];
    if (appState.userData.requests != null &&
        appState.userData.requests.isNotEmpty) {
      items.insertAll(0, [
        getSidebarLink(context, 'Overview', homeScreenPages.overview),
        getSidebarLink(context, 'Tasks', homeScreenPages.tasks),
        getSidebarLink(context, 'Documents', homeScreenPages.documents)
      ]);
    }

    return items;
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
          width: size.width * 0.8,
          child: Theme(
            data: theme.copyWith(
                // Set the transparency here
                canvasColor: theme.secondaryHeaderColor.withOpacity(
                    0.75) //or any other color you want. e.g Colors.blue.withOpacity(0.5)
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
                            width: 1,
                            color: Colors.white,
                            margin: const EdgeInsets.only(
                                left: 35.0, bottom: 150.0),
                          )
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 250),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: getSidebarItems(),
                          ))
                    ],
                  )
                ],
              ),
            ),
          )),
      appBar: appState.currentPage == homeScreenPages.docusign ? null : _appbar,
      body: body,
    );
  }
}
