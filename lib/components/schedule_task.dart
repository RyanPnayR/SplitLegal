import 'package:flutter/material.dart';
import 'package:splitlegal/app.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:splitlegal/components/task.dart';
import 'package:splitlegal/main.dart';
import 'package:splitlegal/models/app_state.dart';
import 'package:splitlegal/services/docusign.service.dart';

class ScheduleTask extends StatelessWidget {
  Activity task;

  ScheduleTask({this.task});

  List<Widget> getTaskDescription(context) {
    return [
      Text(
        task.title != null
            ? task.title
            : 'There was an issue getting task data.',
        softWrap: true,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
    ];
  }

  List<Widget> getCurrentView(context) {
    ThemeData theme = Theme.of(context);
    var container = AppStateContainer.of(context);
    return [
      ...getTaskDescription(context),
      MaterialButton(
        child: Text('Select Date'),
        onPressed: () async {},
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
        ),
        color: theme.secondaryHeaderColor,
        textColor: Colors.white,
        height: 30,
      )
    ];
  }

  List<Widget> getPendingView(context) {
    return [
      ...getTaskDescription(context),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Text(
                  'Signed',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white54,
                  ),
                ),
                Icon(
                  Icons.check_box,
                  size: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> getChildren(context) {
    return task.status == 'current'
        ? getCurrentView(context)
        : getPendingView(context);
  }

  @override
  Widget build(BuildContext context) {
    return Task(task: this.task, children: getChildren(context));
  }
}
