import 'package:flutter/material.dart';

import 'app.dart';
import 'app_state_container.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Wrap your App in your new storage container
  runApp(new AppStateContainer(
    child: new AppRootWidget(),
  ));
}
