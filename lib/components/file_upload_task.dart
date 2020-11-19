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
  List<Widget> getChildren(context) {
    ThemeData theme = Theme.of(context);
    Activity task = widget.task;
    var container = AppStateContainer.of(context);

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
      ),
      Container(
        height: 100,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: files.length > 0
              ? files
                  .map(
                    (file) => Text(
                      file.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white54,
                      ),
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
              } else {
                // User canceled the picker
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
                ? () async {
                    await container.uploadDocuments(files, task.id);
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Task(
      task: widget.task,
      children: getChildren(context),
    );
  }
}
