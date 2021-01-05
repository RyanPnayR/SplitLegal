import 'package:flutter/material.dart';
import 'package:splitlegal/app.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:splitlegal/components/docusign_task.dart';
import 'package:splitlegal/components/file_upload_task.dart';
import 'package:splitlegal/components/payment_task.dart';
import 'package:splitlegal/components/schedule_task.dart';
import 'package:splitlegal/main.dart';
import 'package:splitlegal/models/app_state.dart';
import 'package:splitlegal/services/docusign.service.dart';

class TaskFactory extends StatelessWidget {
  Activity task;
  TaskFactory({this.task});

  @override
  Widget build(BuildContext context) {
    Widget taskWidget;
    switch (task.type) {
      case "payment_request":
        taskWidget = PaymentTask(
          task: task,
        );
        break;
      case "docusign":
        taskWidget = DocusignTask(
          task: task,
        );
        break;
      case "file_upload":
        taskWidget = FileUploadTask(
          task: task,
        );
        break;
      case "schedule":
        taskWidget = ScheduleTask(
          task: task,
        );
        break;
      default:
        taskWidget = Row();
    }
    return taskWidget;
  }
}
