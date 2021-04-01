import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_screen/components/date_time_picker.dart';

// enum TaskStatus {
//   completed,
//   pending,
// }

class FormScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FormScreenState(); //_valueNotifier);
  }

}

class FormScreenState extends State<FormScreen> {

  DateTime pickedDate;
  TimeOfDay time;
  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }

  String _selection;

  List<bool> isSelected = [true, false];

  TextEditingController name = TextEditingController();
  TextEditingController note = TextEditingController();

  CollectionReference ref = Firestore.instance.collection('notes');

  //TaskStatus selectedStatus;

  int _myTaskstatus = 0;
  String taskVal;
  void _handleTaskStatus(int value) {
    setState(() {
      _myTaskstatus = value;
      switch (_myTaskstatus) {
        case 1:
          taskVal='Completed';
          break;
        case 2:
          taskVal='Pending';
          break;
      }
    });
  }

  Set<String> listItem = {
    "Item 1",
    "Item 2",
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      controller: name,
      decoration: InputDecoration(labelText: 'Name',labelStyle: TextStyle(fontWeight: FontWeight.bold),),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }
        return null;
      },
      onSaved: (String value) {},
    );
  }

  Widget _buildNote() {
    return TextFormField(
      controller: note,
      decoration: InputDecoration(labelText: 'Note',labelStyle: TextStyle(fontWeight: FontWeight.bold),),
      validator: (String value) {
        return null;
      },
      onSaved: (String value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Task"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.picture_as_pdf,
            ),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
            ),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(
              Icons.done,
            ),
            onPressed: () => {
              ref.add({
                'name': name.text,
                'note': note.text,
                'category': _selection.toString(),
                'taskstatus': taskVal,
              }).whenComplete(() => Navigator.pop(context))
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(34),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Task Details',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold)),
                Divider(
                  color: Colors.teal,
                ),
                _buildName(),
                SizedBox(height: 15),
                _buildNote(),
                SizedBox(height: 25),
                ListTile(
                  title: Text("Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}"),
                  trailing: Icon(Icons.keyboard_arrow_down),
                  onTap: _pickDate,
                ),
                SizedBox(height: 25),
                Text(
                  'Task Status',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: _myTaskstatus,
                      onChanged: _handleTaskStatus,
                      activeColor: Color(0xff4158ba),
                    ),
                    Text(
                      'Completed',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Radio(
                      value: 2,
                      groupValue: _myTaskstatus,
                      onChanged: _handleTaskStatus,
                      activeColor: Color(0xfffb537f),
                    ),
                    Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 40,
                //   child: ToggleButtons(
                //     children: <Widget>[
                //       Text(
                //         '           Pending           ',
                //         style: TextStyle(
                //           fontSize: 16,
                //         ),
                //       ),
                //       Text(
                //         '           Completed           ',
                //         style: TextStyle(
                //           fontSize: 16,
                //         ),
                //       ),
                //     ],
                //     onPressed: (int index) {
                //       setState(() {
                //         for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++)
                //         {
                //           if (buttonIndex == index) {
                //             isSelected[buttonIndex] = true;
                //             _taskStatus = 'completed';
                //           } else {
                //             isSelected[buttonIndex] = false;
                //             _taskStatus = 'pending';
                //           }
                //         }
                //       });
                //     },
                //     borderWidth: 3,
                //     borderRadius: BorderRadius.circular(5),
                //     isSelected: isSelected,
                //   ),
                // ),
                SizedBox(height: 25),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 1, right: 1),
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      child: DropdownButton(
                        hint: Text('Categories'),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 36,
                        isExpanded: true,
                        underline: SizedBox(),
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 15,
                        ),
                        value: _selection,
                        onChanged: (newValue) {
                          setState(() {
                            _selection = newValue;
                          });
                        },
                        items: listItem.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Divider(
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year-5),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: pickedDate,
    );
    if(date != null)
      setState(() {
        pickedDate = date;
      });
  }
}
