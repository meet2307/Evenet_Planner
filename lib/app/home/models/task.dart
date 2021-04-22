import 'package:meta/meta.dart';

class Task {
  Task({@required this.id, @required this.name, @required this.category, @required this.taskstatus, @required this.note});
  final String id;
  final String name;
  final String category;
  final String taskstatus;
  final String note;

  factory Task.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String category = data['category'];
    final String taskstatus = data['taskstatus'];
    final String note = data['note'];
    return Task(
        id: documentId,
        name: name,
        category: category,
        taskstatus: taskstatus,
        note: note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'taskstatus': taskstatus,
      'note': note,
    };
  }
}
