import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_manager_app/app/home/models/event.dart';
import 'package:event_manager_app/components/date_time_picker.dart';
import 'package:event_manager_app/components/show_alert_dialog.dart';
import 'package:event_manager_app/components/show_exception_alert_dialog.dart';
import 'package:event_manager_app/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class EditEvent extends StatefulWidget {
  const EditEvent({Key key, @required this.database, this.event})
      : super(key: key);
  final Database database;
  final Event event;

  static Future<void> show(BuildContext context,
      {Database database, Event event}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditEvent(database: database, event: event),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  //Map allplaces = Map<int, String>();
  final firestorePlacesInstance = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  DateTime _startDate;
  TimeOfDay _startTime;
  String _comment;
  String _name;
  String _place;
  int _budget;

  @override
  void initState() {
    super.initState();
    //getCloudFirestorePlaces();
    _name = widget.event?.name ?? '';
    _place = widget.event?.place ?? '';
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
    final id = widget.event?.id ?? documentIdFromCurrentDate();
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    if (_validateAndSaveForm()) {
      try {
        final events =
            await widget.database.eventsStream(order: "default").first;
        final allNames = events.map((event) => event.name).toList();
        final places = events.map((event) => event.place).toList();
        final dates = events.map((event) => event.start).toList();
        String tempPlace;
        String tempStart;
        int cnt = 0;

        //This below function is for checking each record one by one and compare to current event whether the event is conflict or not.
        Future<bool> getCloudFirestorePlaces() async {
          await firestorePlacesInstance.doc('places/$id').delete();
          await firestorePlacesInstance.collection("places").get().then(
            (querySnapshot) {
              querySnapshot.docs.forEach(
                (value) {
                  if (value.exists) {
                    tempPlace = value.get("place");
                    tempStart = value.data()["start"].toString();
                    if (tempPlace == _place &&
                        tempStart == start.millisecondsSinceEpoch.toString()) {
                      print(
                          "Key Exits >>>>>> $tempStart   >>>>>>>>>>>   $tempPlace");
                      setState(() {
                        cnt = 1;
                      });
                    } else {}
                  }
                },
              );
            },
          );
          if (cnt != 0) {
            return true;
          } else {
            return false;
          }
        }

        if (widget.event != null) {
          allNames.remove(widget.event.name);
          dates.remove(widget.event.start);
          // allplaces.remove(start.millisecondsSinceEpoch);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different event name',
            defaultActionText: 'OK',
          );
        } else if (dates.contains(start.millisecondsSinceEpoch) &&
            places.contains(_place)) {
          showAlertDialog(
            context,
            title: 'Event Already Exits On This Date, Time & Location',
            content: 'Please choose a different Date, Time & Location',
            defaultActionText: 'OK',
          );
        } else if (await getCloudFirestorePlaces()) {
          showAlertDialog(
            context,
            title: 'Place & Date Time Conflicts',
            content: 'Please choose a different Place & Date Time',
            defaultActionText: 'OK',
          );
        } else {
          final event = Event(
              id: id,
              name: _name,
              place: _place,
              budget: _budget,
              start: start,
              comment: _comment);
          await widget.database.setEvent(event);

          //This below line is for adding record in places collection to check whether the event is conflict or not.
          firestorePlacesInstance.doc('places/$id').set({
            "place": _place,
            "start": start.millisecondsSinceEpoch,
          });

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
        decoration: InputDecoration(labelText: 'Event Location'),
        initialValue: _place,
        validator: (value) =>
            value.isNotEmpty ? null : 'Location can\'t be empty',
        onSaved: (value) => _place = value,
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:login_screen/app/home/models/event.dart';
// import 'package:login_screen/components/date_time_picker.dart';
// import 'package:login_screen/components/show_alert_dialog.dart';
// import 'package:login_screen/components/show_exception_alert_dialog.dart';
// import 'package:login_screen/services/database.dart';
//
// class EditEvent extends StatefulWidget {
//   const EditEvent({Key key, @required this.database, this.event}) : super(key: key);
//   final Database database;
//   final Event event;
//
//   static Future<void> show(BuildContext context, {Database database, Event event}) async {
//     await Navigator.of(context, rootNavigator: true).push(
//       MaterialPageRoute(
//         builder: (context) => EditEvent(database: database, event: event),
//         fullscreenDialog: true,
//       ),
//     );
//   }
//
//   @override
//   _EditEventState createState() => _EditEventState();
// }
//
// class _EditEventState extends State<EditEvent> {
//   Map allplaces = Map<int, String>();
//   final firestoreInstance = FirebaseFirestore.instance;
//
//   final _formKey = GlobalKey<FormState>();
//
//   DateTime _startDate;
//   TimeOfDay _startTime;
//   String _comment;
//   String _name;
//   String _place;
//   int _budget;
//
//   @override
//   void initState() {
//     super.initState();
//     _name = widget.event?.name ?? '';
//     _place = widget.event?.place ?? '';
//     _budget = widget.event?.budget ?? null;
//     final start = widget.event?.start ?? DateTime.now();
//     _startDate = DateTime(start.year, start.month, start.day);
//     _startTime = TimeOfDay.fromDateTime(start);
//     _comment = widget.event?.comment ?? '';
//     getCloudFirestorePlaces();
//   }
//
//   bool _validateAndSaveForm() {
//     final form = _formKey.currentState;
//     if (form.validate()) {
//       form.save();
//       return true;
//     }
//     return false;
//   }
//   Future getCloudFirestorePlaces() async{
//     firestoreInstance.collection("places").get().then((querySnapshot) {
//       print("All PLaces Time >> ");
//       querySnapshot.docs.forEach((value) {
//         allplaces[value.get("start")] = value.get("place");
//         print(allplaces);
//       });
//     }).catchError((onError) {
//       print("ERROR");
//       print(onError);
//     });
//   }
//
//   Future<void> _submit() async {
//     final id = widget.event?.id ?? documentIdFromCurrentDate();
//     final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
//         _startTime.hour, _startTime.minute);
//     if (_validateAndSaveForm()) {
//       try {
//         final events = await widget.database.eventsStream().first;
//         final allNames = events.map((event) => event.name).toList();
//         final places = events.map((event) => event.place).toList();
//         final dates = events.map((event) => event.start).toList();
//         if (widget.event != null) {
//           allNames.remove(widget.event.name);
//           dates.remove(widget.event.start);
//           //allplaces.remove(start.millisecondsSinceEpoch);
//         }
//
//         if (allNames.contains(_name)) {
//           showAlertDialog(
//             context,
//             title: 'Name already used',
//             content: 'Please choose a different event name',
//             defaultActionText: 'OK',
//           );
//         }
//         // else if(allplaces.containsKey(start.millisecondsSinceEpoch) && allplaces.containsValue(_place)){
//         //   showAlertDialog(
//         //     context,
//         //     title: 'Place & Date Time Conflicts',
//         //     content: 'Please choose a different Place & Date Time',
//         //     defaultActionText: 'OK',
//         //   );
//         // }
//         else if(dates.contains(DateTime(_startDate.year, _startDate.month, _startDate.day, _startTime.hour, _startTime.minute)) && places.contains(_place)) {
//           showAlertDialog(
//             context,
//             title: 'Event Already Exits On This Date, Time & Location',
//             content: 'Please choose a different Date, Time & Location',
//             defaultActionText: 'OK',
//           );
//         }
//         else {
//           final event = Event(
//               id: id,
//               name: _name,
//               place: _place,
//               budget: _budget,
//               start: start,
//               comment: _comment
//           );
//           await widget.database.setEvent(event);
//
//           firestoreInstance.doc('places/$id').set({
//             "place" : _place,
//             "start" : start.millisecondsSinceEpoch,
//           });
//
//           Navigator.of(context).pop();
//         }
//       } on FirebaseException catch (e) {
//         showExceptionAlertDialog(
//           context,
//           title: 'Operation failed',
//           exception: e,
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 2.0,
//         title: Text(widget.event == null ? 'New Event' : 'Edit Event'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.done_rounded),
//             tooltip: 'Save',
//             onPressed: _submit,
//             //onPressed: (){},// => _setEntryAndDismiss(context),
//           ),
//         ],
//       ),
//       body: _buildContents(),
//       backgroundColor: Colors.grey[200],
//     );
//   }
//
//   Widget _buildContents() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: _buildForm(),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: _buildFormChildren(),
//       ),
//     );
//   }
//
//   List<Widget> _buildFormChildren() {
//     return [
//       TextFormField(
//         decoration: InputDecoration(labelText: 'Event name'),
//         initialValue: _name,
//         validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
//         onSaved: (value) => _name = value,
//       ),
//       TextFormField(
//         decoration: InputDecoration(labelText: 'Event Location'),
//         initialValue: _place,
//         validator: (value) => value.isNotEmpty ? null : 'Location can\'t be empty',
//         onSaved: (value) => _place = value,
//       ),
//       TextFormField(
//         decoration: InputDecoration(labelText: 'Total Budget'),
//         initialValue: _budget != null ? '$_budget' : null,
//         keyboardType: TextInputType.numberWithOptions(
//           signed: false,
//           decimal: false,
//         ),
//         onSaved: (value) => _budget = int.tryParse(value) ?? 0,
//       ),
//       SizedBox(height: 8.0),
//       _buildStartDate(),
//       SizedBox(height: 8.0),
//       _buildComment(),
//     ];
//   }
//   Widget _buildStartDate() {
//     return DateTimePicker(
//       labelText: 'Date & Time',
//       selectedDate: _startDate,
//       selectedTime: _startTime,
//       onSelectedDate: (date) => setState(() => _startDate = date),
//       onSelectedTime: (time) => setState(() => _startTime = time),
//     );
//   }
//
//   Widget _buildComment() {
//     return TextField(
//       keyboardType: TextInputType.text,
//       maxLength: 50,
//       controller: TextEditingController(text: _comment),
//       decoration: InputDecoration(
//         labelText: 'Comment',
//         labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
//       ),
//       style: TextStyle(fontSize: 20.0, color: Colors.black),
//       maxLines: null,
//       onChanged: (comment) => _comment = comment,
//     );
//   }
// }
