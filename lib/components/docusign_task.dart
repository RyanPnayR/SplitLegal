import 'package:flutter/material.dart';
import 'package:splitlegal/app.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:splitlegal/components/task.dart';
import 'package:splitlegal/main.dart';
import 'package:splitlegal/models/app_state.dart';
import 'package:splitlegal/services/docusign.service.dart';

class DocusignTask extends StatelessWidget {
  Activity task;

  DocusignTask({this.task});

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
        child: Text('Sign Document'),
        onPressed: () {
          container.state.isLoading = true;
          container.state.selectedTask = task;
          Navigator.of(context).pushNamed('/home');
          container.state.currentPage = homeScreenPages.docusign;

          Future<String> url = getIt<DocusignService>()
              .getUserInfoUri(container.state.user, this.task);

          url.then((value) {
            container.state.isLoading = false;
            container.state.docusignUrl = value;
            Navigator.of(context).pushNamed('/home');
          });
        },
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
