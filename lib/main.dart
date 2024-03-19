import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/app.dart';
import 'package:todo_list_app/database.dart';
import 'package:todo_list_app/firebase_options.dart';
import 'package:todo_list_app/controllers/tasks_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //name: 'todo list app',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.lazyPut<TasksController>(() => TasksController());
  final tasksController = Get.find<TasksController>();
  final database = Database();
  tasksController.tasks = await database.LoadData();
  runApp(MyApp());
}
