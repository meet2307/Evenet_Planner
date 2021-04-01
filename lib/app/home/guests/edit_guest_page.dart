import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/app/home/models/guest.dart';
import 'package:login_screen/components/show_alert_dialog.dart';
import 'package:login_screen/components/show_exception_alert_dialog.dart';
import 'package:login_screen/services/database.dart';

class EditGuestPage extends StatefulWidget {
  const EditGuestPage(
      {Key key, @required this.database, @required this.event, this.guest})
      : super(key: key);
  final Database database;
  final Event event;
  final Guest guest;

  static Future<void> show(
      {BuildContext context,
      Database database,
      Event event,
      Guest guest}) async {
    //final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditGuestPage(database: database, event: event, guest: guest),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditGuestPageState createState() => _EditGuestPageState();
}

class _EditGuestPageState extends State<EditGuestPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _gender = '';
  String _acb = '';
  String _note;
  String _invitation = '';
  String _phone;
  String _emailid;
  String _address;

  @override
  void initState() {
    super.initState();
    if (widget.guest != null) {
      _name = widget.guest.name;
      _gender = widget.guest.gender;
      _acb = widget.guest.acb;
      _note = widget.guest.note;
      _invitation = widget.guest.invitation;
      _phone = widget.guest.phone;
      _emailid = widget.guest.emailid;
      _address = widget.guest.address;
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
        final guests =
            await widget.database.guestsStream(eventId: widget.event.id).first;
        final allNames = guests.map((guest) => guest.name).toList();
        if (widget.guest != null) {
          allNames.remove(widget.guest.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.guest?.id ?? documentIdFromCurrentDate();
          final guest = Guest(
            id: id,
            name: _name,
            gender:_gender,
            acb: _acb,
            invitation:_invitation,
            note: _note,
            phone:_phone,
            emailid: _emailid,
            address:_address,
          );
          await widget.database.setGuest(widget.event, guest);
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
        title: Text(widget.guest == null ? 'New Guest' : 'Edit Guest'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.contact_phone_outlined),
            tooltip: 'phone',
            onPressed: () {},
          ),
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
        decoration: InputDecoration(labelText: 'Guest name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      // TextFormField(
      //   decoration: InputDecoration(labelText: 'Guest gender'),
      //   initialValue: _gender,
      //   validator: (value) => value.isNotEmpty ? null : 'Gender can\'t be empty',
      //   onSaved: (value) => _gender = value,
      // ),
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
            _buildGenderType('Male'),
            SizedBox(width: 3),
            _buildGenderType('Female'),
          ],
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Container(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildACBType('Adult'),
            SizedBox(width: 3),
            _buildACBType('Child'),
            SizedBox(width: 3),
            _buildACBType('Baby'),
          ],
        ),
      ),
      // TextFormField(
      //   decoration: InputDecoration(labelText: 'Adult,Child,Baby'),
      //   initialValue: _acb,
      //   validator: (value) => value.isNotEmpty ? null : 'Choice can\'t be empty',
      //   onSaved: (value) => _acb = value,
      // ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Note'),
        initialValue: _note,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
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
                "Invitation Status :",
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(width: 10),
            _buildInvitationType('Sent'),
            SizedBox(width: 3),
            _buildInvitationType('Not-Sent'),
          ],
        ),
      ),
      // TextFormField(
      //   decoration: InputDecoration(labelText: 'Invitation Status'),
      //   initialValue: _invitation,
      //   validator: (value) =>
      //       value.isNotEmpty ? null : 'Invitation Status can\'t be empty',
      //   onSaved: (value) => _invitation = value,
      // ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Phone Number'),
        initialValue: _phone,
        validator: (value) =>
            value.isNotEmpty ? null : 'Phone Number can\'t be empty',
        onSaved: (value) => _phone = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email Id'),
        initialValue: _emailid,
        validator: (value) =>
            value.isNotEmpty ? null : 'Email Id can\'t be empty',
        onSaved: (value) => _emailid = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Address'),
        initialValue: _address,
        validator: (value) =>
            value.isNotEmpty ? null : 'Address can\'t be empty',
        onSaved: (value) => _address = value,
      ),
    ];
  }

  Widget _buildGenderType(String gender) {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          color: _gender == gender
              ? Colors.teal.shade500
              : Colors.black,
          //borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              gender,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _gender = gender;
        });
      },
    );
  }
  Widget _buildACBType(String acb) {
    return InkWell(
      child: Container(
        height: 40,
        width: 113.5,
        decoration: BoxDecoration(
          color: _acb == acb
              ? Colors.teal.shade500
              : Colors.black,
          //borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              acb,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _acb = acb;
        });
      },
    );
  }
  Widget _buildInvitationType(String invitation) {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        decoration: BoxDecoration(
          color: _invitation == invitation
              ? Colors.teal.shade500
              : Colors.black,
          //borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              invitation,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _invitation = invitation;
        });
      },
    );
  }
}
