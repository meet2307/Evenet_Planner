import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/app/home/models/task.dart';
import 'package:login_screen/app/home/tasks/edit_task_page.dart';
import 'package:login_screen/app/home/tasks/task_list_tile.dart';
import 'package:login_screen/components/list_items_builder.dart';
import 'package:login_screen/components/show_exception_alert_dialog.dart';
import 'package:login_screen/services/database.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({@required this.database, @required this.event});
  final Database database;
  final Event event;

  static Future<void> show(BuildContext context, Event event) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => TasksPage(database: database, event: event),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Task task) async {
    try {
      await database.deleteTask(event, task);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
        stream: database.eventStream(eventId: event.id),
        builder: (context, snapshot) {
          final event = snapshot.data;
          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Scaffold(
              appBar: AppBar(
                title: Text('Tasks'),
                actions: <Widget>[
                  // FlatButton(
                  //   child: Text(
                  //     'Logout',
                  //     style: TextStyle(
                  //       fontSize: 18.0,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   onPressed: () => _confirmSignOut(context),
                  // ),
                ],
              ),
              body: _buildContents(context, event),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => EditTaskPage.show(
                  context: context,
                  database: database,
                  event: event,
                ),
              ),
            ),
          );
        });
  }

  Widget _buildContents(BuildContext context, Event event) {
    return StreamBuilder<List<Task>>(
      stream: database.tasksStream(eventId: event.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<Task>(
          snapshot: snapshot,
          itemBuilder: (context, task) => Dismissible(
            key: Key('task-${task.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, task),
            child: TaskListTile(
              task: task,
              onTap: () => EditTaskPage.show(
                context: context,
                database: database,
                event: event,
                task: task,
              ),
            ),
          ),
        );
      },
    );
  }
  // Widget _buildContents(BuildContext context, Event event) {
  //   return StreamBuilder<List<Task>>(
  //     stream: database.tasksStream(eventId: event.id),
  //     builder: (context, snapshot) {
  //       return ListItemsBuilder<Task>(
  //         snapshot: snapshot,
  //         itemBuilder: (context, task) => Dismissible(
  //           key: Key('task-${task.id}'),
  //           background: Container(color: Colors.red),
  //           direction: DismissDirection.endToStart,
  //           onDismissed: (direction) => _delete(context, task),
  //           child: TaskListTile(
  //             task: task,
  //             onTap: () => EditTaskPage.show(
  //               context: context,
  //               database: database,
  //               event: event,
  //               task: task,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
}
