import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitlegal/components/task_factory.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var container = AppStateContainer.of(context);
      container.loadUserTasks().then(() {});
    });
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

  List<Widget> getTasks(String status) {
    return appState.currentRequest.tasks
        .where((element) => element.status == status)
        .toList()
        .asMap()
        .map(
          (i, task) => MapEntry(
            i,
            TaskFactory(
              task: task,
            ),
          ),
        )
        .values
        .toList();
  }

  Widget get currentTasks {
    List<Widget> tasks = getTasks('current');
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: tasks.length > 0
          ? tasks
          : [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'No current tasks right now. Check back later.',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ],
    );
  }

  Widget get pendingTasks {
    List<Widget> tasks = getTasks('pending');
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          "Pending",
          style: TextStyle(fontSize: 16.0, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        children: tasks.length > 0
            ? tasks
            : [
                Text(
                  'No pending tasks.',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
      ),
    );
  }

  Widget get completedTasks {
    List<Widget> tasks = getTasks('completed');
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
        children: tasks.length > 0
            ? tasks
            : [
                Text(
                  'You have no completed tasks.',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
      ),
    );
  }
}
