import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/components/date_time_picker.dart';
import 'package:login_screen/components/show_alert_dialog.dart';
import 'package:login_screen/components/show_exception_alert_dialog.dart';
import 'package:login_screen/services/database.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key key, @required this.database, this.event}) : super(key: key);
  final Database database;
  final Event event;

  static Future<void> show(BuildContext context, {Database database, Event event}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => CreateEvent(database: database, event: event),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();

  DateTime _startDate;
  TimeOfDay _startTime;
  String _comment;
  String _name;
  int _budget;

  @override
  void initState() {
    super.initState();
    _name = widget.event?.name ?? '';
    _budget = widget.event?.budget ?? null;
    final start = widget.event?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);
    _comment = widget.event?.comment ?? '';
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
        final events = await widget.database.eventsStream().first;
        final allNames = events.map((event) => event.name).toList();
        if (widget.event != null) {
          allNames.remove(widget.event.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different event name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.event?.id ?? documentIdFromCurrentDate();
          final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
              _startTime.hour, _startTime.minute);
          final event = Event(
              id: id,
              name: _name,
              budget: _budget,
              start: start,
              comment: _comment
          );
          await widget.database.setEvent(event);
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
        title: Text(widget.event == null ? 'New Event' : 'Edit Event'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.done_rounded),
            tooltip: 'Save',
            onPressed: _submit,
            //onPressed: (){},// => _setEntryAndDismiss(context),
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
        decoration: InputDecoration(labelText: 'Event name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Total Budget'),
        initialValue: _budget != null ? '$_budget' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _budget = int.tryParse(value) ?? 0,
      ),
      SizedBox(height: 8.0),
      _buildStartDate(),
      SizedBox(height: 8.0),
      _buildComment(),
    ];
  }
  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Date & Time',
      selectedDate: _startDate,
      selectedTime: _startTime,
      onSelectedDate: (date) => setState(() => _startDate = date),
      onSelectedTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _comment),
      decoration: InputDecoration(
        labelText: 'Comment',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
    );
  }
}
