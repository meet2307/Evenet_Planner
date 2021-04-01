import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/app/home/models/vendors.dart';
import 'package:login_screen/components/show_alert_dialog.dart';
import 'package:login_screen/components/show_exception_alert_dialog.dart';
import 'package:login_screen/services/database.dart';


class EditVendorPage extends StatefulWidget {
  const EditVendorPage({Key key, @required this.database, @required this.event, this.vendor}) : super(key: key);
  final Database database;
  final Event event;
  final Vendor vendor;

  static Future<void> show(
      {BuildContext context,  Database database, Event event, Vendor vendor}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditVendorPage(database: database, event: event, vendor: vendor),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditVendorPageState createState() => _EditVendorPageState();
}

class _EditVendorPageState extends State<EditVendorPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _category = '';
  String _note;
  int _estimated_amount;
  String _phone;
  String _emailid;
  String _website;
  String _address;


  @override
  void initState() {
    super.initState();
    if (widget.vendor != null) {
      _name = widget.vendor.name;
      _category = widget.vendor.category;
      _note = widget.vendor.note;
      _estimated_amount = widget.vendor.estimated_amount;
      _phone = widget.vendor.phone;
      _emailid = widget.vendor.emailid;
      _website = widget.vendor.website;
      _address = widget.vendor.address;
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
        final vendors = await widget.database.vendorsStream(eventId: widget.event.id).first;
        final allNames = vendors.map((vendor) => vendor.name).toList();
        if (widget.vendor != null) {
          allNames.remove(widget.vendor.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.vendor?.id ?? documentIdFromCurrentDate();
          final vendor = Vendor(
              id: id, 
              name: _name, 
              category: _category,
              estimated_amount: _estimated_amount,
              note: _note,
              phone:_phone,
              emailid: _emailid,
              website: _website,
              address:_address,

          );
          await widget.database.setVendor(widget.event, vendor);
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
        title: Text(widget.vendor == null ? 'New Vendor' : 'Edit Vendor'),
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
        decoration: InputDecoration(labelText: 'Web Site'),
        initialValue: _website != null ? '$_website' : null,
        validator: (value) =>
        value.isNotEmpty ? null : 'Web Site can\'t be empty',
        onSaved: (value) => _website = value ?? null,
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
