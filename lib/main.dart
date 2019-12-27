import 'package:flutter/material.dart';
import 'package:splitlegal/screens/home_screen.dart';

import 'app.dart';
import 'app_state_container.dart';

void main() {
  // Wrap your App in your new storage container
  runApp(new AppStateContainer(
    child: new AppRootWidget(),
  ));
}
