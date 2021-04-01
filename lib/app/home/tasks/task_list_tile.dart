import 'package:flutter/material.dart';
import 'package:login_screen/app/home/models/task.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({Key key, @required this.task, this.onTap}) : super(key: key);
  final Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
