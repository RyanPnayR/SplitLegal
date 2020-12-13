import 'package:flutter/material.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:url_launcher/url_launcher.dart';

import 'overview.dart';

class MyTeam extends StatefulWidget {
  @override
  _MyTeamState createState() => new _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          'My Team',
          style: TextStyle(fontSize: 16),
        )),
        elevation: 0.0,
        backgroundColor: theme.primaryColor,
      ),
      backgroundColor: theme.primaryColor,
      body: Container(
          width: double.infinity,
          height: 200,
          color: theme.primaryColor,
          margin: EdgeInsets.all(20),
          child: OverviewTaskBox(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Text(
                            'AR',
                            style: TextStyle(fontSize: 40, color: Colors.black),
                          ),
                          radius: 50,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Alex Rodriquez",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Expert Family Lawyer",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1),
                        ),
                        SizedBox(height: 10),
                        MaterialButton(
                          child: Text('Contact'),
                          onPressed: () async {
                            String url =
                                "mailto:ryanpnayr@gmail.com?subject=Split Legal Help";
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          color: Theme.of(context).secondaryHeaderColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                          ),
                          textColor: Colors.white,
                          height: 30,
                          minWidth: 150,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
