import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:intl/intl.dart';
import 'package:splitlegal/pdf_viewer.dart';
import 'package:splitlegal/screens/divorce_form_select.dart';

import 'models/app_state.dart';

class SplitLegalDashboardForm extends StatelessWidget {
  Reference form;

  SplitLegalDashboardForm({this.form});

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

  getCard(BuildContext context) {
    var container = AppStateContainer.of(context);
    ThemeData theme = Theme.of(context);

    return new Container(
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
        child: new Container(
          margin: new EdgeInsets.only(left: 50, top: 10),
          child: new Column(children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    form.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  )
                ]),
            MaterialButton(
              child: Text('Review'),
              onPressed: () async {
                container
                    .getUsersForm(await form.getDownloadURL(), form.name)
                    .then((path) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PdfViewPage(path: path, title: form.name)));
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              color: theme.secondaryHeaderColor,
              textColor: Colors.white,
              height: 30,
            )
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    ThemeData theme = Theme.of(context);
    return new Container(
        margin: const EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 24.0,
        ),
        child: new Stack(
          children: <Widget>[
            getCard(context),
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          'Documents',
          style: TextStyle(fontSize: 16),
        )),
        elevation: 0.0,
        backgroundColor: theme.primaryColor,
      ),
      backgroundColor: theme.primaryColor,
      body: Center(
        child: FutureBuilder(
            future: container.getUserDocuments(container.state.user),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (snapshot.hasData) {
                List<Reference> documents = snapshot.data;

                List<SplitLegalDashboardForm> formsWidgets =
                    documents.map((doc) {
                  return new SplitLegalDashboardForm(form: doc);
                }).toList();

                return Center(
                    child: ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: formsWidgets,
                ));
              } else {
                return Row();
              }
            }),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
