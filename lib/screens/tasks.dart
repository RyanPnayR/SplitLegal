import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitlegal/components/task.dart';
import 'package:splitlegal/models/app_state.dart';

import '../app_state_container.dart';

class Tasks extends StatefulWidget {
  Tasks();

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  AppState appState;
  ThemeData theme;
  TabController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
    theme = Theme.of(context);
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
            children: [currentTasks, pendingTasks, completedTasks],
          )),
    );
  }

  Widget get currentTasks {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: appState.currentRequest.tasks
          .where((element) => element.status == "current")
          .toList()
          .asMap()
          .map(
            (i, task) => MapEntry(
              i,
              Task(
                task: task,
              ),
            ),
          )
          .values
          .toList(),
    );
  }

  Widget get pendingTasks {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          "Pending",
          style: TextStyle(fontSize: 16.0, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        children: [
          ...appState.currentRequest.tasks
              .where((element) => element.status == "pending")
              .toList()
              .asMap()
              .map(
                (i, task) => MapEntry(
                  i,
                  Task(
                    task: task,
                  ),
                ),
              )
              .values
              .toList(),
        ],
      ),
    );
  }

  Widget get completedTasks {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          "Completed",
          style: TextStyle(fontSize: 16.0, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        children: appState.currentRequest.tasks
            .where((element) => element.status == "completed")
            .toList()
            .asMap()
            .map(
              (i, task) => MapEntry(
                i,
                Task(
                  task: task,
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}
