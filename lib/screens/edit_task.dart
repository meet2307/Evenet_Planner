// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class EditTask extends StatefulWidget {
//
//   DocumentSnapshot docTOedit;
//   EditTask({this.docTOedit});
//
//   @override
//   State<StatefulWidget> createState() {
//     return EditTaskState();
//   }
//
//
// }
//
// class EditTaskState extends State<EditTask> {
//
//   String _selection;
//
//   TextEditingController name = TextEditingController();
//   TextEditingController note = TextEditingController();
//   TextEditingController cate = TextEditingController();
//   TextEditingController status = TextEditingController();
//
//
//   CollectionReference ref = Firestore.instance.collection('notes');
//
//   int _myTaskstatus = 0;
//   String taskVal;
//   void _handleTaskStatus(int value) {
//     setState(() {
//       _myTaskstatus = value;
//       switch (_myTaskstatus) {
//         case 1:
//           taskVal='Completed';
//           break;
//         case 2:
//           taskVal='Pending';
//           break;
//       }
//     });
//   }
//
//   Set<String> listItem = {
//     "Item 1",
//     "Item 2",
//   };
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   Widget _buildName() {
//     return TextFormField(
//       controller: name,
//       decoration: InputDecoration(labelText: 'Name'),
//       validator: (String value) {
//         if (value.isEmpty) {
//           return 'Name is Required';
//         }
//         return null;
//       },
//       onSaved: (String value) {},
//     );
//   }
//
//   Widget _buildNote() {
//     return TextFormField(
//       controller: note,
//       decoration: InputDecoration(labelText: 'Note'),
//       validator: (String value) {
//         return null;
//       },
//       onSaved: (String value) {},
//     );
//   }
//
//   @override
//   void initState() {
//     name = TextEditingController(text: widget.docTOedit.data['name']);
//     note = TextEditingController(text: widget.docTOedit.data['note']);
//     cate  = TextEditingController(text: widget.docTOedit.data['category']);
//     status  = TextEditingController(text: widget.docTOedit.data['taskstatus']);
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Task"),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.picture_as_pdf,
//             ),
//             onPressed: () => {},
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.delete,
//             ),
//             onPressed: () => {
//               widget.docTOedit.reference.delete().whenComplete(() => Navigator.pop(context))
//
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.done,
//             ),
//             onPressed: () {
//             widget.docTOedit.reference.updateData({
//             'name': name.text,
//             'note': note.text,
//             'category' : _selection.toString(),
//             'taskstatus': taskVal,
//             }).whenComplete(() => Navigator.pop(context));
//             }
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: EdgeInsets.all(34),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text('Task Details',
//                     style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.teal,
//                         fontWeight: FontWeight.bold)),
//                 Divider(
//                   color: Colors.teal,
//                 ),
//                 _buildName(),
//                 SizedBox(height: 15),
//                 _buildNote(),
//                 SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Radio(
//                       value: 1,
//                       groupValue: _myTaskstatus,
//                       onChanged: _handleTaskStatus,
//                       activeColor: Color(0xff4158ba),
//                     ),
//                     Text(
//                       'Completed',
//                       style: TextStyle(fontSize: 16.0),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Radio(
//                       value: 2,
//                       groupValue: _myTaskstatus,
//                       onChanged: _handleTaskStatus,
//                       activeColor: Color(0xfffb537f),
//                     ),
//                     Text(
//                       'Pending',
//                       style: TextStyle(
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 1, right: 1),
//                     child: Container(
//                       padding: EdgeInsets.only(left: 10, right: 10),
//                       decoration: BoxDecoration(
//                           border: Border.all(color: Colors.teal, width: 2),
//                           borderRadius: BorderRadius.circular(15)),
//                       child: DropdownButton(
//                         hint: Text('Categories'),
//                         icon: Icon(Icons.arrow_drop_down),
//                         iconSize: 36,
//                         isExpanded: true,
//                         underline: SizedBox(),
//                         style: TextStyle(
//                           color: Colors.teal,
//                           fontSize: 15,
//                         ),
//                         //value: _selection,
//                         onChanged: (newValue) {
//                           setState(() {
//                             //_selection = newValue;
//                           });
//                         },
//                         items: listItem.map(
//                                 (valueItem) {
//                               return DropdownMenuItem(
//                                 value: valueItem,
//                                 child: Text(valueItem),
//                               );
//                             }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 15),
//
//                 // Text('Subtasks',
//                 //     style: TextStyle(
//                 //         fontSize: 20,
//                 //         color: Colors.teal,
//                 //         fontWeight: FontWeight.bold)),
//                 Divider(
//                   color: Colors.teal,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
