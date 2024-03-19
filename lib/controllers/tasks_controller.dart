import 'package:get/get.dart';
import 'package:todo_list_app/model/task.dart';
import 'package:todo_list_app/widgets/task_data_source.dart';

class TasksController extends GetxController {
  List<Task> tasks = [];
  TaskDataSource taskDataSource = TaskDataSource(tasks: []);
}
