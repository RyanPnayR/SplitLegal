import 'package:flutter/material.dart';

import 'app.dart';
import 'app_state_container.dart';

void main() async {
  // Wrap your App in your new storage container
  runApp(new AppStateContainer(
    child: new AppRootWidget(),
  ));
}
