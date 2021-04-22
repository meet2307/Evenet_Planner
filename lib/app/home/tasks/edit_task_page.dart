import 'package:event_manager_app/app/home/models/event.dart';
import 'package:event_manager_app/app/home/models/task.dart';
import 'package:event_manager_app/components/show_alert_dialog.dart';
import 'package:event_manager_app/components/show_exception_alert_dialog.dart';
import 'package:event_manager_app/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage(
      {Key key, @required this.database, @required this.event, this.task})
      : super(key: key);
  final Database database;
  final Event event;
  final Task task;

  static Future<void> show(
      {BuildContext context, Database database, Event event, Task task}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditTaskPage(database: database, event: event, task: task),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _category = '';
  String _taskstatus = '';
  String _note;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _name = widget.task.name;
      _category = widget.task.category;
      _taskstatus = widget.task.taskstatus;
      _note = widget.task.note;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final tasks =
            await widget.database.tasksStream(eventId: widget.event.id).first;
        final allNames = tasks.map((task) => task.name).toList();
        if (widget.task != null) {
          allNames.remove(widget.task.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different task name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.task?.id ?? documentIdFromCurrentDate();
          final task = Task(
            id: id,
            name: _name,
            category: _category,
            taskstatus: _taskstatus,
            note: _note,
          );
          await widget.database.setTask(widget.event, task);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.done_rounded),
            tooltip: 'Save',
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    Size size = MediaQuery.of(context).size;
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Task name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      SizedBox(height: 10),
      Text(
        "Category :",
        style: TextStyle(fontSize: 16),
      ),
      SizedBox(height: 10),
      Container(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildCategoryType('Accessories'),
            SizedBox(width: 3),
            _buildCategoryType('Accommodation'),
            SizedBox(width: 3),
            _buildCategoryType('Ceremony'),
            SizedBox(width: 3),
            _buildCategoryType('Flower & Decor'),
            SizedBox(width: 3),
            _buildCategoryType('Health & Beauty'),
            SizedBox(width: 3),
            _buildCategoryType('Photo & Video'),
            SizedBox(width: 3),
            _buildCategoryType('Reception'),
            SizedBox(width: 3),
            _buildCategoryType('Transportation'),
            SizedBox(width: 3),
            _buildCategoryType('Jewelry'),
          ],
        ),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Note'),
        initialValue: _note,
        validator: (value) =>
            value.isNotEmpty ? null : null,
        onSaved: (value) => _note = value,
      ),
      SizedBox(
        height: 15,
      ),
      Container(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Center(
              child: Text(
                "Task Status :",
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(width: 10),
            _buildTaskStatusType('Completed'),
            SizedBox(width: 3),
            _buildTaskStatusType('Pending'),
          ],
        ),
      ),
    ];
  }

  Widget _buildTaskStatusType(String title) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
        height: double.infinity,
        width: size.width *0.272,
        decoration: BoxDecoration(
          color: _taskstatus == title
              ? Colors.teal.shade500
              : Colors.black,
          //borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _taskstatus = title;
        });
      },
    );
  }

  Widget _buildCategoryType(String category) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      child: Container(
        height: double.infinity,
        width: 150,
        decoration: BoxDecoration(
          color: _category == category
              ? Colors.teal.shade500
              : Colors.black,
          //borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              category,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _category = category;
        });
      },
    );
  }
}
