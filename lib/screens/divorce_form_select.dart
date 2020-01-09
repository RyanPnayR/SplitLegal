import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splitlegal/app.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:splitlegal/models/app_state.dart';

class DivorceFormOptions extends StatelessWidget {
  List<SplitLegalForm> forms;
  Function selectForm;
  SplitLegalForm selectedFrom;

  DivorceFormOptions(
      List<SplitLegalForm> forms, selectForm, SplitLegalForm selectedFrom) {
    this.forms = forms;
    this.selectForm = selectForm;
    this.selectedFrom = selectedFrom;
  }

  List<Widget> getOptions(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var container = AppStateContainer.of(context);

    return this.forms.map((form) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(children: [
              ButtonTheme(
                  minWidth: 350,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      color: this.selectedFrom != null &&
                              this.selectedFrom.id == form.id
                          ? theme.secondaryHeaderColor
                          : theme.hoverColor,
                      textColor: Colors.white,
                      child: Text(
                        form.displayName,
                      ),
                      onPressed: () {
                        selectForm(form);
                      })),
              Positioned(
                  bottom: 0,
                  top: 0,
                  left: 300,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.help),
                    color: this.selectedFrom != null &&
                            this.selectedFrom.id == form.id
                        ? theme.hoverColor
                        : theme.secondaryHeaderColor,
                    onPressed: () {
                      container.showErrorDialog(
                          context,
                          [
                            Text(
                              'Description',
                              style: Theme.of(context).textTheme.title,
                            ),
                            Text(form.form_info)
                          ],
                          [
                            FlatButton(
                              child: Text('Got it!'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                          true);
                    },
                  ))
            ])
          ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(children: getOptions(context)));
  }
}

class DivorceFormSelect extends StatefulWidget {
  @override
  DivorceFormSelectState createState() => new DivorceFormSelectState();
}

class DivorceFormSelectState extends State<DivorceFormSelect> {
  SplitLegalForm selectedFrom;
  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          elevation: 0.0,
          backgroundColor: theme.primaryColor,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(children: [
          Text(
            'Please select',
            style: theme.textTheme.display1,
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: container.getForms(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                if (snapshot.hasData) {
                  List<DocumentSnapshot> documents = snapshot.data.documents;

                  List<SplitLegalForm> items = documents.map((document) {
                    return SplitLegalForm.fromMap(
                        document.documentID, document.data);
                  }).toList();

                  items.sort((a, b) {
                    return a.order.compareTo(b.order);
                  });

                  return DivorceFormOptions(items, (form) {
                    setState(() {
                      this.selectedFrom = form;
                    });
                  }, this.selectedFrom);
                } else {
                  return Row();
                }
              }),
          this.selectedFrom != null
              ? new Expanded(
                  child: new Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonTheme(
                        minWidth: double.infinity,
                        height: 50,
                        buttonColor: Colors.green,
                        child: RaisedButton(
                          textColor: theme.textTheme.display1.color,
                          child: new Text('Continue'),
                          onPressed: () async {
                            String userFormId =
                                await container.startForm(this.selectedFrom);
                            Navigator.of(context).pushReplacementNamed('/survey',
                                arguments: FormRouteArguments(
                                    this.selectedFrom, userFormId));
                          },
                        ),
                      )),
                )
              : Row(),
        ]) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
