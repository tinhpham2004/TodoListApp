import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/app.dart';
import 'package:todo_list_app/firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'todo list app',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}
