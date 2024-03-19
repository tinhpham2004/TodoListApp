import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:todo_list_app/model/task.dart';
import 'package:todo_list_app/values/colors.dart';

class TaskDataSource extends DataGridSource {
  TaskDataSource({List<Task>? tasks}) {
    _tasks = tasks!
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'id', value: e.id),
              DataGridCell<String>(
                  columnName: 'time', value: e.time.toString()),
              DataGridCell<String>(
                  columnName: 'index', value: indexIncrease().toString()),
              DataGridCell<String>(columnName: 'content', value: e.content),
              DataGridCell<Container>(
                columnName: 'status',
                value: Container(
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      color: AppColors.transparent,
                      borderRadius: BorderRadius.circular(20.sp),
                      border: Border.all(width: 0.5),
                    ),
                    child: Text(e.status)),
              ),
              DataGridCell<Icon>(
                columnName: 'edit',
                value: Icon(
                  Icons.edit,
                  color: AppColors.edit,
                ),
              ),
              DataGridCell<Icon>(
                columnName: 'delete',
                value: Icon(
                  Icons.delete,
                  color: AppColors.delete,
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _tasks = [];
  int index = 1;

  int indexIncrease() {
    return index++;
  }

  @override
  List<DataGridRow> get rows => _tasks;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        //padding: EdgeInsets.all(32.sp),
        child: dataGridCell.columnName != 'edit' &&
                dataGridCell.columnName != 'delete' &&
                dataGridCell.columnName != 'status'
            ? Text(
                dataGridCell.value,
                textAlign: TextAlign.center,
              )
            : dataGridCell.value,
      );
    }).toList());
  }
}
