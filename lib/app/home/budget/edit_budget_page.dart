import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/app/home/models/budget.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/components/show_alert_dialog.dart';
import 'package:login_screen/components/show_exception_alert_dialog.dart';
import 'package:login_screen/services/database.dart';


class EditBudgetPage extends StatefulWidget {
  const EditBudgetPage({Key key, @required this.database, @required this.event, this.budget}) : super(key: key);
  final Database database;
  final Event event;
  final Budget budget;

  static Future<void> show(
      {BuildContext context,  Database database, Event event, Budget budget}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditBudgetPage(database: database, event: event, budget: budget),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditBudgetPageState createState() => _EditBudgetPageState();
}

class _EditBudgetPageState extends State<EditBudgetPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _category = '';
  String _note;
  int _estimated_amount;


  @override
  void initState() {
    super.initState();
    if (widget.budget != null) {
      _name = widget.budget.name;
      _category = widget.budget.category;
      _note = widget.budget.note;
      _estimated_amount = widget.budget.estimated_amount;
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
        final tasks = await widget.database.tasksStream(eventId: widget.event.id).first;
        final allNames = tasks.map((task) => task.name).toList();
        if (widget.budget != null) {
          allNames.remove(widget.budget.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.budget?.id ?? documentIdFromCurrentDate();
          final budget = Budget(
              id: id, 
              name: _name, 
              category: _category,
              estimated_amount: _estimated_amount,
              note: _note,
          );
          await widget.database.setBudget(widget.event, budget);
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
        title: Text(widget.budget == null ? 'New Budget' : 'Edit Budget'),
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.contact_phone_outlined),
          //   tooltip: 'phone',
          //   onPressed: (){},
          // ),
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
            _buildCategoryType('One'),
            SizedBox(width: 3),
            _buildCategoryType('Two'),
            SizedBox(width: 3),
            _buildCategoryType('Three'),
            SizedBox(width: 3),
            _buildCategoryType('Four'),
            SizedBox(width: 3),
            _buildCategoryType('Five'),
          ],
        ),
      ),
      // TextFormField(
      //   decoration: InputDecoration(labelText: 'Category'),
      //   initialValue: _category,
      //   validator: (value) => value.isNotEmpty ? null : 'Category can\'t be empty',
      //   onSaved: (value) => _category = value,
      // ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Note'),
        initialValue: _note,
        validator: (value) => value.isNotEmpty ? null : 'Note Status can\'t be empty',
        onSaved: (value) => _note = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Total Budget'),
        initialValue: _estimated_amount != null ? '$_estimated_amount' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _estimated_amount = int.tryParse(value) ?? 0,
      ),
    ];
  }

  Widget _buildCategoryType(String category) {
    return InkWell(
      child: Container(
        height: 40,
        width: 100,
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
