import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/model/task.dart';

class Database {
  final tasksCollection = FirebaseFirestore.instance.collection('tasks');

  Future<List<Task>> LoadData() async {
    List<Task> result = [];
    await tasksCollection.get().then((value) {
      List<DocumentSnapshot> tasks = value.docs;
      tasks.forEach((element) {
        String id = ((element.data() as dynamic)['id'] as dynamic).toString();
        String content =
            ((element.data() as dynamic)['content'] as dynamic).toString();
        String status =
            ((element.data() as dynamic)['status'] as dynamic).toString();
        Timestamp timeStamp = (element.data() as dynamic)['time'] as dynamic;
        DateTime time = timeStamp.toDate();
        result.add(Task(id: id, content: content, status: status, time: time));
      });
    });
    return result;
  }

  Future<void> AddTask(Task task) async {
    await tasksCollection.doc(task.id).set({
      'id': task.id,
      'content': task.content,
      'status': task.status,
      'time': task.time,
    });
  }

  Future<void> UpdateTask(Task task) async {
    await tasksCollection.doc(task.id).update({
      'content': task.content,
      'status': task.status,
      'time': task.time,
    });
  }

  Future<void> DeleteTask(String id) async {
    await tasksCollection.doc(id).delete();
  }
}
