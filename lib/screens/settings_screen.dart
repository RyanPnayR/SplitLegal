import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:intl/intl.dart';
import 'package:splitlegal/models/app_state.dart';

import 'models/app_state.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<Settings> {
  Widget getListTextField(label, value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(labelText: label, border: InputBorder.none),
      style: TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    ThemeData theme = Theme.of(context);
    UserData userData = container.state.userData;

    return new Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "My Info",
            style:
                TextStyle(fontFamily: 'Roboto', fontSize: 14, letterSpacing: 4),
          ),
        ),
        backgroundColor: theme.primaryColor,
        body: Center(
            child: Container(
                width: 300,
                child: new ListView(children: <Widget>[
                  getListTextField(
                      'Name', userData.firstName + ' ' + userData.lastName),
                  getListTextField('Email', container.state.user.email),
                  SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                      child: Text("Reset Password"),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      color: Theme.of(context).secondaryHeaderColor,
                      textColor: Colors.white,
                      onPressed: () {
                        List<Widget> messageToDisplay = [
                          Text(
                            'Request Sent',
                            style: theme.textTheme.title,
                          ),
                          Text(
                              'Your request to reset your password has been sent to your email.')
                        ];
                        container.showLoadingDialog(context);
                        container
                            .resetPassword(container.state.user.email)
                            .catchError((error) {
                          messageToDisplay = [
                            Text(
                              'Uh, oh!',
                              style: theme.textTheme.title,
                            ),
                            Text(
                                'An error happened during your request. Please try again or contact support.')
                          ];
                        }).whenComplete(() {
                          container.hideDialog(context);
                          container.showErrorDialog(context, messageToDisplay);
                        });
                      }),
                ]))));
  }
}
