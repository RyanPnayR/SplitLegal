import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:splitlegal/models/app_state.dart';

class FileUploadTask extends StatelessWidget {
  Activity task;
  FileUploadTask({this.task});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var container = AppStateContainer.of(context);

    return Column(
      children: [
        MaterialButton(
          child: Text("Upload"),
          onPressed: () async {
            FilePickerResult result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );
            if (result != null) {
              List<File> files =
                  result.paths.map((path) => File(path)).toList();
            } else {
              // User canceled the picker
            }
          },
        )
      ],
    );
  }
}
