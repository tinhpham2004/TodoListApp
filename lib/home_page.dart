import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:todo_list_app/cancel_button.dart';
import 'package:todo_list_app/database.dart';
import 'package:todo_list_app/model/task.dart';
import 'package:todo_list_app/task_data_source.dart';
import 'package:todo_list_app/tasks_controller.dart';
import 'package:todo_list_app/values/colors.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final tasksController = Get.find<TasksController>();

  void orderByTime() {
    tasksController.tasks.sort(((a, b) => b.time.compareTo(a.time)));
  }

  @override
  void initState() {
    super.initState();
    orderByTime();
    tasksController.taskDataSource =
        TaskDataSource(tasks: tasksController.tasks);
  }

  final database = Database();

  final addTaskController = TextEditingController();
  final updateTaskController = TextEditingController();

  void addDialog(BuildContext context) {
    addTaskController.text = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Task',
          ),
          content: TextField(
            controller: addTaskController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(60.sp),
              ),
            ),
          ),
          actions: <Widget>[
            CancelButton(),
            GestureDetector(
              onTap: () async {
                String id = database.tasksCollection.doc().id;
                String content = addTaskController.text;
                String status = 'Incomplete';
                DateTime time = DateTime.now();
                Task task =
                    Task(id: id, content: content, status: status, time: time);
                tasksController.tasks.add(task);
                setState(() {
                  orderByTime();
                  tasksController.taskDataSource =
                      TaskDataSource(tasks: tasksController.tasks);
                });
                database.AddTask(task);
                Navigator.pop(context);
              },
              child: Container(
                  width: 150.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                      color: AppColors.add,
                      borderRadius: BorderRadius.circular(30.sp)),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  )),
            ),
          ],
        );
      },
    );
  }

  void checkAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Check All Completed Tasks',
          ),
          content: Text('Are you sure you want to delete all Completed task?'),
          actions: <Widget>[
            CancelButton(),
            GestureDetector(
              onTap: () async {
                List<Task> tasks = [];
                tasksController.tasks.forEach(
                  (element) {
                    if (element.status != 'Completed') {
                      tasks.add(element);
                    } else {
                      database.DeleteTask(element.id);
                    }
                  },
                );
                tasksController.tasks = tasks;
                setState(() {
                  orderByTime();
                  tasksController.taskDataSource =
                      TaskDataSource(tasks: tasksController.tasks);
                });
                Navigator.pop(context);
              },
              child: Container(
                  width: 150.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                      color: AppColors.add,
                      borderRadius: BorderRadius.circular(30.sp)),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  )),
            ),
          ],
        );
      },
    );
  }

  void updateDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Task',
          ),
          content: TextField(
            controller: updateTaskController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(60.sp),
              ),
            ),
          ),
          actions: <Widget>[
            CancelButton(),
            GestureDetector(
              onTap: () async {
                task.content = updateTaskController.text;
                task.time = DateTime.now();
                for (int i = 0; i < tasksController.tasks.length; i++) {
                  if (tasksController.tasks[i].id == task.id) {
                    tasksController.tasks[i].content = task.content;
                    tasksController.tasks[i].time = task.time;
                  }
                }
                setState(() {
                  orderByTime();
                  tasksController.taskDataSource =
                      TaskDataSource(tasks: tasksController.tasks);
                });
                database.UpdateTask(task);
                Navigator.pop(context);
              },
              child: Container(
                  width: 150.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                      color: AppColors.add,
                      borderRadius: BorderRadius.circular(30.sp)),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  )),
            ),
          ],
        );
      },
    );
  }

  void deleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Task',
          ),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            CancelButton(),
            GestureDetector(
              onTap: () async {
                for (int i = 0; i < tasksController.tasks.length; i++) {
                  if (tasksController.tasks[i].id == id) {
                    tasksController.tasks.removeAt(i);
                    break;
                  }
                }
                setState(() {
                  orderByTime();
                  tasksController.taskDataSource =
                      TaskDataSource(tasks: tasksController.tasks);
                });
                database.DeleteTask(id);
                Navigator.pop(context);
              },
              child: Container(
                  width: 150.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                      color: AppColors.delete,
                      borderRadius: BorderRadius.circular(30.sp)),
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  )),
            ),
          ],
        );
      },
    );
  }

  void onEdit(DataGridCellTapDetails details) {
    final task = tasksController
        .taskDataSource[details.rowColumnIndex.rowIndex - 1]
        .getCells();
    String id = task[0].value.toString();
    DateTime? time = DateTime.tryParse(task[1].value.toString());
    String content = task[3].value.toString();
    String status = '';
    for (int i = 0; i < tasksController.tasks.length; i++) {
      if (tasksController.tasks[i].id == id) {
        status = tasksController.tasks[i].status;
      }
    }
    updateTaskController.text = content;
    updateDialog(
        context, Task(id: id, content: content, status: status, time: time!));
  }

  void onDelete(DataGridCellTapDetails details) {
    final task = tasksController
        .taskDataSource[details.rowColumnIndex.rowIndex - 1]
        .getCells();
    String id = task[0].value.toString();
    deleteDialog(context, id);
  }

  String nextStatus(String status) {
    switch (status) {
      case 'Incomplete':
        return 'In-progress';
      case 'In-progress':
        return 'Completed';
      default:
        return status;
    }
  }

  void onTapStatus(DataGridCellTapDetails details) {
    final task = tasksController
        .taskDataSource[details.rowColumnIndex.rowIndex - 1]
        .getCells();
    String id = task[0].value.toString();
    DateTime time = DateTime.now();
    String content = task[3].value.toString();
    String status = 'Completed';
    for (int i = 0; i < tasksController.tasks.length; i++) {
      if (tasksController.tasks[i].id == id &&
          tasksController.tasks[i].status != 'Completed') {
        tasksController.tasks[i].status =
            nextStatus(tasksController.tasks[i].status);
        tasksController.tasks[i].time = time;
        status = tasksController.tasks[i].status;
      }
    }
    Task _task = Task(id: id, content: content, status: status, time: time);
    setState(() {
      orderByTime();
      tasksController.taskDataSource =
          TaskDataSource(tasks: tasksController.tasks);
    });
    database.UpdateTask(_task);
  }

  void onPressStatus(DataGridCellLongPressDetails details) {
    final task = tasksController
        .taskDataSource[details.rowColumnIndex.rowIndex - 1]
        .getCells();
    String id = task[0].value.toString();
    DateTime time = DateTime.now();
    String content = task[3].value.toString();
    String status = '';
    for (int i = 0; i < tasksController.tasks.length; i++) {
      if (tasksController.tasks[i].id == id) {
        tasksController.tasks[i].status = 'Incomplete';
        tasksController.tasks[i].time = time;
        status = tasksController.tasks[i].status;
      }
    }
    Task _task = Task(id: id, content: content, status: status, time: time);
    setState(() {
      orderByTime();
      tasksController.taskDataSource =
          TaskDataSource(tasks: tasksController.tasks);
    });
    database.UpdateTask(_task);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Todo List App'),
        ),
        body: Stack(
          children: [
            Expanded(
              child: SfDataGrid(
                onCellTap: (details) {
                  switch (details.column.columnName) {
                    case 'edit':
                      onEdit(details);
                      break;
                    case 'delete':
                      onDelete(details);
                      break;
                    case 'status':
                      onTapStatus(details);
                      break;
                  }
                },
                onCellLongPress: (details) {
                  if (details.column.columnName == 'status') {
                    onPressStatus(details);
                  }
                },
                source: tasksController.taskDataSource,
                columns: [
                  GridColumn(
                    visible: false,
                    columnName: 'id',
                    label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '',
                      ),
                    ),
                  ),
                  GridColumn(
                    visible: false,
                    columnName: 'time',
                    label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '',
                      ),
                    ),
                  ),
                  GridColumn(
                    columnWidthMode: ColumnWidthMode.fitByCellValue,
                    columnName: 'index',
                    label: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '#',
                      ),
                    ),
                  ),
                  GridColumn(
                    columnWidthMode: ColumnWidthMode.fill,
                    columnName: 'content',
                    label: Container(
                      alignment: Alignment.center,
                      child: Text('Task Name'),
                    ),
                  ),
                  GridColumn(
                    columnWidthMode: ColumnWidthMode.fill,
                    columnName: 'status',
                    label: Container(
                      alignment: Alignment.center,
                      child: Text('Status'),
                    ),
                  ),
                  GridColumn(
                    columnWidthMode: ColumnWidthMode.fitByColumnName,
                    columnName: 'edit',
                    label: Container(
                      alignment: Alignment.center,
                      child: Text('Edit'),
                    ),
                  ),
                  GridColumn(
                    columnWidthMode: ColumnWidthMode.fitByColumnName,
                    columnName: 'delete',
                    label: Container(
                      alignment: Alignment.center,
                      child: Text('Delete'),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  addDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                      color: AppColors.add, shape: BoxShape.circle),
                  child: Icon(
                    Icons.add,
                    color: AppColors.white,
                    size: 70.sp,
                  ),
                ),
              ),
              bottom: 100.h,
              right: 80.w,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  checkAllDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                      color: AppColors.edit, shape: BoxShape.circle),
                  child: Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: 70.sp,
                  ),
                ),
              ),
              bottom: 100.h,
              right: 250.w,
            ),
          ],
        ),
      ),
    );
  }
}
