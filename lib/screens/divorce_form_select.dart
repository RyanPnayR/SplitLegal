import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:splitlegal/models/app_state.dart' as appState;

class DivorceFormOption extends StatelessWidget {
  List<appState.Form> forms;

  DivorceFormOption(List<appState.Form> forms) {
    this.forms = forms;
  }

  List<Widget> getOptions() {
    return this.forms.map((form) {
      return Text(form.displayName);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    return Center(child: ListView(children: getOptions()));
  }
}

class DivorceFormSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(""), actions: <Widget>[]),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
            stream: container.getForms(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (snapshot.hasData) {
                List<DocumentSnapshot> documents = snapshot.data.documents;

                List<appState.Form> items = documents.map((document) {
                  return appState.Form.fromMap(document.data);
                }).toList();

                return DivorceFormOption(items);
              }
            }),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
