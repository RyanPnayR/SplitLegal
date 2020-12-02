import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:splitlegal/components/task.dart';
import 'package:splitlegal/models/app_state.dart';

class FileUploadTask extends StatefulWidget {
  Activity task;

  FileUploadTask({this.task});

  @override
  _FileUploadTaskState createState() => _FileUploadTaskState();
}

class _FileUploadTaskState extends State<FileUploadTask> {
  List<PlatformFile> files = [];

  void removeFile(PlatformFile file) {
    setState(() {
      files.remove(file);
    });
  }

  List<Widget> getTaskDescription(context) {
    Activity task = widget.task;
    return [
      Text(
        task.title != null
            ? task.title
            : 'There was an issue getting task data.',
        softWrap: true,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
      )
    ];
  }

  List<Widget> getCurrentView(context) {
    ThemeData theme = Theme.of(context);
    Activity task = widget.task;
    var container = AppStateContainer.of(context);
    return [
      ...getTaskDescription(context),
      Container(
        height: 100,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: files.length > 0
              ? files
                  .map(
                    (file) => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.highlight_remove),
                          onPressed: () {
                            removeFile(file);
                          },
                        ),
                        Text(
                          file.name,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList()
              : [Row()],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
            child: Text('Add Documents'),
            onPressed: () async {
              FilePickerResult result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );
              if (result != null) {
                setState(() {
                  files.addAll(result.files);
                });
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            color: theme.secondaryHeaderColor,
            textColor: Colors.white,
            height: 30,
          ),
          MaterialButton(
            child: Text('Upload Documents'),
            disabledColor: Colors.white24,
            disabledTextColor: Colors.black45,
            onPressed: files.length > 0
                ? () {
                    setState(() {
                      container.state.isLoading = true;
                    });

                    container.uploadDocuments(files, task.id).then((fileUrls) {
                      task.activityData.addAll({"files": fileUrls});
                      task.status = 'pending';

                      container.updateActivity(task).then((value) {
                        container.setUpUserData().then(
                          (value) {
                            setState(
                              () {
                                container.state.isLoading = false;
                              },
                            );
                          },
                        );
                      });
                    });
                  }
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            color: theme.secondaryHeaderColor,
            textColor: Colors.white,
            height: 30,
          ),
        ],
      ),
    ];
  }

  List<Widget> getPendingView(context) {
    List<dynamic> activityFiles = widget.task.activityData['files'];
    return [
      ...getTaskDescription(context),
      Container(
        height: 100,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: activityFiles.length > 0
              ? activityFiles.map((file) {
                  List<String> urlParts = file.split('/');
                  List<String> fileParts =
                      urlParts[urlParts.length - 1].split('%2F');
                  String name = fileParts[fileParts.length - 1].split('?')[0];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5, top: 4),
                        child: Icon(Icons.circle, size: 8),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  );
                }).toList()
              : [Row()],
        ),
      ),
    ];
  }

  List<Widget> getChildren(context) {
    Activity task = widget.task;

    return task.status == 'current'
        ? getCurrentView(context)
        : getPendingView(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Task(
      task: widget.task,
      children: getChildren(context),
    );
  }
}
