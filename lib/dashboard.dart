import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:intl/intl.dart';
import 'package:splitlegal/pdf_viewer.dart';

import 'models/app_state.dart';

class SplitLegalDashboardForm extends StatelessWidget {
  UserForm form;

  SplitLegalDashboardForm(this.form);

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
                  Text(
                    'Last Updated: ' +
                        DateFormat.yMd().add_jm().format(form.updatedAt),
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Status: ' + form.status,
                    style: TextStyle(fontSize: 12),
                  ),
                ]),
            MaterialButton(
              child: Text('Review'),
              onPressed: () {
                container.getUsersForm(form.id).then((path) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PdfViewPage(path: path, title: form.name)));
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
              color: form.status == 'completed'
                  ? theme.secondaryHeaderColor
                  : theme.hoverColor,
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
      body: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: container.getUserForms(container.state.user),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (snapshot.hasData) {
                  List<DocumentSnapshot> documents = snapshot.data.documents;

                  List<UserForm> forms = documents.map((document) {
                    return UserForm.fromMap(document.documentID, document.data);
                  }).toList();

                  List<SplitLegalDashboardForm> formsWidgets = forms
                      .where((form) => form.status != 'pending')
                      .map((form) {
                    return new SplitLegalDashboardForm(form);
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
