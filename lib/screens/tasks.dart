import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Tasks extends StatefulWidget {
  Tasks({Key key}) : super(key: key);

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: false,
              automaticallyImplyLeading: false,
              backgroundColor: theme.primaryColor,
              toolbarHeight: 25,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        "Up next",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              expandedHeight: 50.0,
            ),
          ];
        },
        body: ListView(
          children: [
            Container(
              color: theme.primaryColor,
              margin: EdgeInsets.all(20),
              child: ExpansionTile(
                childrenPadding: EdgeInsets.all(20),
                tilePadding: EdgeInsets.only(top: 10, left: 20),
                title: Text(
                  'Fill in your information',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                children: [
                  Text(
                    'ads;dlfka;sdlkfja;skdfj ;akdjf as;kd fjasdjk fasd; j as;lk jfas;lk jasfj kads ;kjaf ;lkjasf adfasdf',
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
