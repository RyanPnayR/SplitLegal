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
  ThemeData theme;
  String countyValue = 'Orange';
  String requestValue = 'Prenup';
  String commentsValue = '';

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
    List<Widget> questions = [countyQuestion, requestType, comments];
    var container = AppStateContainer.of(context);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        resizeToAvoidBottomInset: false,
        persistentFooterButtons: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: ButtonTheme(
              minWidth: double.infinity,
              height: 50,
              buttonColor: Colors.green,
              child: RaisedButton(
                textColor: theme.textTheme.display1.color,
                child: new Text('Continue'),
                onPressed: () async {
                  UserFilingRequest request = new UserFilingRequest(
                      comments: commentsValue,
                      location: countyValue,
                      requestType: commentsValue,
                      userId: appState.user.uid);
                  container.addUserFilingRequests(request);
                },
              ),
            ),
          ),
        ],
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: questions.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              itemBuilder: (BuildContext context, int index) {
                return questions[index];
              },
            ),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    theme = Theme.of(context);
    appState = container.state;
    Widget body = _pageToDisplay;

    return new Scaffold(
      body: body,
    );
  }

  Widget get countyQuestion {
    List<String> options = ['Seminole', 'Orange'];
    return new Column(
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(children: [
                Container(
                  height: 30,
                  width: 300,
                  color: Colors.transparent,
                  child: new Container(
                      padding: EdgeInsets.only(left: 20),
                      decoration: new BoxDecoration(
                          color: theme.secondaryHeaderColor,
                          borderRadius: new BorderRadius.all(
                            Radius.circular(40.0),
                          )),
                      child: new Center(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text(
                            "In which county are you in?",
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.help),
                            color: theme.hoverColor,
                            onPressed: () {},
                          ),
                        ],
                      ))),
                ),
              ])
            ]),
        Container(
          width: 250,
          alignment: Alignment.center,
          color: theme.primaryColor,
          child: DropdownButton<String>(
            isExpanded: true,
            value: countyValue,
            onChanged: (String newValue) {
              setState(() {
                countyValue = newValue;
              });
            },
            style: TextStyle(color: Colors.blue),
            selectedItemBuilder: (BuildContext context) {
              return options.map((String value) {
                return Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    countyValue,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList();
            },
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget get requestType {
    List<String> requestOptions = <String>['Prenup'];
    return new Column(
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(children: [
                Container(
                  height: 30,
                  width: 300,
                  color: Colors.transparent,
                  child: new Container(
                      padding: EdgeInsets.only(left: 20),
                      decoration: new BoxDecoration(
                          color: theme.secondaryHeaderColor,
                          borderRadius: new BorderRadius.all(
                            Radius.circular(40.0),
                          )),
                      child: new Center(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text(
                            "What Service are you needing?",
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.help),
                            color: theme.hoverColor,
                            onPressed: () {},
                          ),
                        ],
                      ))),
                ),
              ])
            ]),
        Container(
          width: 250,
          alignment: Alignment.center,
          color: theme.primaryColor,
          child: DropdownButton<String>(
            isExpanded: true,
            value: requestValue,
            onChanged: (String newValue) {
              setState(() {
                requestValue = newValue;
              });
            },
            style: TextStyle(color: Colors.blue),
            selectedItemBuilder: (BuildContext context) {
              return requestOptions.map((String value) {
                return Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    requestValue,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList();
            },
            items: requestOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget get comments {
    return new Column(
      children: [
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(children: [
                Container(
                  height: 30,
                  width: 300,
                  color: Colors.transparent,
                  child: new Container(
                      decoration: new BoxDecoration(
                          color: theme.secondaryHeaderColor,
                          borderRadius: new BorderRadius.all(
                            Radius.circular(40.0),
                          )),
                      child: new Center(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text(
                            "What else do we need to know?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ))),
                ),
              ])
            ]),
        Container(
          width: 250,
          alignment: Alignment.center,
          color: theme.primaryColor,
          child: Container(
            margin: EdgeInsets.only(top: 0),
            child: TextField(
              onChanged: (text) {
                commentsValue = text;
              },
              decoration: const InputDecoration(
                  labelText: 'Notes/Comments',
                  labelStyle: TextStyle(color: Colors.white54)),
              style: TextStyle(color: Colors.white),
              autofocus: false,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
        ),
      ],
    );
  }
}
