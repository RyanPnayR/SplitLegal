import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splitlegal/app_state_container.dart';

import 'models/app_state.dart';

class SplitLegalDashboardForm extends StatelessWidget {
  getThumbnail(IconData icon, Color color) {
    return new Container(
        margin: new EdgeInsets.symmetric(vertical: 16.0),
        alignment: FractionalOffset.centerLeft,
        child: new Icon(
          icon,
          size: 92,
          color: color,
        ));
  }

  getCard() {
    return new Container(
      height: 124.0,
      width: 250,
      margin: new EdgeInsets.only(left: 46.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    ThemeData theme = Theme.of(context);

    return new Container(
        height: 120.0,
        margin: const EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 24.0,
        ),
        child: new Stack(
          children: <Widget>[
            getCard(),
            getThumbnail(Icons.insert_drive_file, theme.secondaryHeaderColor),
          ],
        ));
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: container.getUserForms(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (snapshot.hasData) {
                  List<DocumentSnapshot> documents = snapshot.data.documents;

                  List<UserForm> forms = documents.map((document) {
                    return UserForm.fromMap(document.data);
                  }).toList();

                  List<SplitLegalDashboardForm> formsWidgets = forms
                      .where((form) => form.status == 'completed')
                      .map((form) {
                    return new SplitLegalDashboardForm();
                  }).toList();

                  return Column(
                    children: formsWidgets,
                  );
                } else {
                  return Row();
                }
              }),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
