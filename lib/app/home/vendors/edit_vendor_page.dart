import 'package:event_manager_app/app/home/models/event.dart';
import 'package:event_manager_app/app/home/models/vendors.dart';
import 'package:event_manager_app/components/show_alert_dialog.dart';
import 'package:event_manager_app/components/show_exception_alert_dialog.dart';
import 'package:event_manager_app/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class EditVendorPage extends StatefulWidget {
  const EditVendorPage(
      {Key key, @required this.database, @required this.event, this.vendor})
      : super(key: key);
  final Database database;
  final Event event;
  final Vendor vendor;

  static Future<void> show(
      {BuildContext context,
      Database database,
      Event event,
      Vendor vendor}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditVendorPage(database: database, event: event, vendor: vendor),
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
        final vendors =
            await widget.database.vendorsStream(eventId: widget.event.id).first;
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
            phone: _phone,
            emailid: _emailid,
            website: _website,
            address: _address,
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
        children: List.unmodifiable(() sync* {
          yield* _buildFormChildren();
          // yield SizedBox(height: 20);
          // yield* _buildFormChildren();
        }()),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    List<Widget> list = [
      TextFormField(
        decoration: InputDecoration(labelText: 'Vendor name'),
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
      TextFormField(
        decoration: InputDecoration(labelText: 'Budget'),
        initialValue: _estimated_amount != null ? '$_estimated_amount' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _estimated_amount = int.tryParse(value) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Phone Number'),
        keyboardType: TextInputType.phone,
        initialValue: _phone,
        validator: (value) => value.isNotEmpty
            ? value.length == 10
            ? null
            : 'Please Enter Valid Phone Number'
            : 'Phone Number can\'t be empty',
        onSaved: (value) => _phone = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email Id'),
        keyboardType: TextInputType.emailAddress,
        initialValue: _emailid,
        validator: (value) =>
            value.isNotEmpty ? null : 'Email Id can\'t be empty',
        onSaved: (value) => _emailid = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Web Site'),
        keyboardType: TextInputType.url,
        initialValue: _website != null ? '$_website' : null,
        validator: (value) =>
            value.isNotEmpty ? null : 'Web Site can\'t be empty',
        onSaved: (value) => _website = value ?? null,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Address'),
        keyboardType: TextInputType.streetAddress,
        initialValue: _address,
        validator: (value) =>
            value.isNotEmpty ? null : 'Address can\'t be empty',
        onSaved: (value) => _address = value,
      ),
    ];
    return list;
  }

  Widget _buildCategoryType(String category) {
    return InkWell(
      child: Container(
        height: 40,
        width: 150,
        decoration: BoxDecoration(
          color: _category == category ? Colors.teal.shade500 : Colors.black,
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
