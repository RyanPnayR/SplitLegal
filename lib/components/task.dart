import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:splitlegal/models/app_state.dart';

class Task extends StatelessWidget {
  Activity task;
  List<Widget> children;
  Task({this.task, this.children});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var container = AppStateContainer.of(context);

    return Container(
        color: theme.primaryColor,
        child: new Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  spreadRadius: 5,
                  offset: new Offset(0, 1.0),
                ),
              ],
            ),
            child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                    backgroundColor: theme.primaryColor,
                    childrenPadding: EdgeInsets.all(20),
                    tilePadding: EdgeInsets.only(top: 10, left: 20),
                    title: Text(
                      task.title,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    children: children))));
  }
}
