import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:splitlegal/services/docusign.service.dart';
import 'app.dart';
import 'app_state_container.dart';
import 'package:firebase_core/firebase_core.dart';

final getIt = GetIt.instance;

void main() async {
  void setup() {
    getIt.registerSingleton<DocusignService>(DocusignService());
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();
  // Wrap your App in your new storage container
  runApp(new AppStateContainer(
    child: new AppRootWidget(),
  ));
}
