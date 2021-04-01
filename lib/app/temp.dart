// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
//
// // enum TaskStatus {
// //   completed,
// //   pending,
// // }
//
// class FormScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return FormScreenState(); //_valueNotifier);
//   }
// }
//
// class FormScreenState extends State<FormScreen> {
//   // String _selection;
//
//   List<bool> isSelectedA = [true, false];
//   List<bool> isSelectedB = [true, false, true];
//   List<bool> isSelectedC = [true, false];
//
//   TextEditingController name = TextEditingController();
//   TextEditingController note = TextEditingController();
//
//   // CollectionReference ref = Firestore.instance.collection('notes');
//
//   //TaskStatus selectedStatus;
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
//       decoration: InputDecoration(
//         labelText: 'Name',
//         labelStyle: TextStyle(fontWeight: FontWeight.bold),
//       ),
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
//       decoration: InputDecoration(
//         labelText: 'Note',
//         labelStyle: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       validator: (String value) {
//         return null;
//       },
//       onSaved: (String value) {},
//     );
//   }
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
//             onPressed: () => {},
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.done,
//             ),
//             onPressed: () => {
//               // ref.add({
//               //   'name': name.text,
//               //   'note': note.text,
//               //   'category': _selection.toString(),
//               //   'taskstatus': taskVal,
//               // }).whenComplete(() => Navigator.pop(context))
//             },
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
//               //crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text('Task Details',
//                     style: TextStyle(
//                         fontSize: 25,
//                         color: Colors.teal,
//                         fontWeight: FontWeight.bold)),
//                 Divider(
//                   color: Colors.teal,
//                 ),
//                 SizedBox(height: 5),
//                 _buildName(),
//                 SizedBox(height: 15),
//                 Card(
//                   child: ToggleButtons(
//                     isSelected: isSelectedA,
//                     selectedColor: Colors.white,
//                     color: Colors.black,
//                     fillColor: Colors.teal.shade500,
//                     renderBorder: false,
//                     //splashColor: Colors.red,
//                     highlightColor: Colors.teal.shade300,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Text('Male', style: TextStyle(fontSize: 18)),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Text('Female', style: TextStyle(fontSize: 18)),
//                       ),
//                     ],
//                     onPressed: (int newIndex) {
//                       setState(() {
//                         for (int index = 0;
//                         index < isSelectedA.length;
//                         index++) {
//                           if (index == newIndex) {
//                             isSelectedA[index] = true;
//                           } else {
//                             isSelectedA[index] = false;
//                           }
//                         }
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 Card(
//                   child: ToggleButtons(
//                     isSelected: isSelectedB,
//                     selectedColor: Colors.white,
//                     color: Colors.black,
//                     fillColor: Colors.teal.shade500,
//                     renderBorder: false,
//                     //splashColor: Colors.red,
//                     highlightColor: Colors.teal.shade300,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Text('Adult', style: TextStyle(fontSize: 18)),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Text('Child', style: TextStyle(fontSize: 18)),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Text('Baby', style: TextStyle(fontSize: 18)),
//                       ),
//                     ],
//                     onPressed: (int newIndex) {
//                       setState(() {
//                         for (int index = 0;
//                         index < isSelectedB.length;
//                         index++) {
//                           if (index == newIndex) {
//                             isSelectedB[index] = true;
//                           } else {
//                             isSelectedB[index] = false;
//                           }
//                         }
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 5),
//                 _buildNote(),
//                 SizedBox(height: 15),
//                 Card(
//                   child: ToggleButtons(
//                     isSelected: isSelectedC,
//                     selectedColor: Colors.white,
//                     color: Colors.black,
//                     fillColor: Colors.teal.shade500,
//                     renderBorder: false,
//                     //splashColor: Colors.red,
//                     highlightColor: Colors.teal.shade300,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Text('Invitation Sent ',
//                             style: TextStyle(fontSize: 18)),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Text('Not Sent', style: TextStyle(fontSize: 18)),
//                       ),
//                     ],
//                     onPressed: (int newIndex) {
//                       setState(() {
//                         for (int index = 0;
//                         index < isSelectedC.length;
//                         index++) {
//                           if (index == newIndex) {
//                             isSelectedC[index] = true;
//                           } else {
//                             isSelectedC[index] = false;
//                           }
//                         }
//                       });
//                     },
//                   ),
//                 ),
//                 // SizedBox(height: 5),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.start,
//                 //   children: <Widget>[
//                 //     Radio(
//                 //       value: 1,
//                 //       groupValue: _myTaskstatus,
//                 //       onChanged: _handleTaskStatus,
//                 //       activeColor: Color(0xff4158ba),
//                 //     ),
//                 //     Text(
//                 //       'Completed',
//                 //       style: TextStyle(fontSize: 16.0),
//                 //     ),
//                 //   ],
//                 // ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.start,
//                 //   children: <Widget>[
//                 //     Radio(
//                 //       value: 2,
//                 //       groupValue: _myTaskstatus,
//                 //       onChanged: _handleTaskStatus,
//                 //       activeColor: Color(0xfffb537f),
//                 //     ),
//                 //     Text(
//                 //       'Pending',
//                 //       style: TextStyle(
//                 //         fontSize: 16.0,
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 // SizedBox(
//                 //   height: 40,
//                 //   child: ToggleButtons(
//                 //     children: <Widget>[
//                 //       Text(
//                 //         '           Pending           ',
//                 //         style: TextStyle(
//                 //           fontSize: 16,
//                 //         ),
//                 //       ),
//                 //       Text(
//                 //         '           Completed           ',
//                 //         style: TextStyle(
//                 //           fontSize: 16,
//                 //         ),
//                 //       ),
//                 //     ],
//                 //     onPressed: (int index) {
//                 //       setState(() {
//                 //         for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++)
//                 //         {
//                 //           if (buttonIndex == index) {
//                 //             isSelected[buttonIndex] = true;
//                 //             _taskStatus = 'completed';
//                 //           } else {
//                 //             isSelected[buttonIndex] = false;
//                 //             _taskStatus = 'pending';
//                 //           }
//                 //         }
//                 //       });
//                 //     },
//                 //     borderWidth: 3,
//                 //     borderRadius: BorderRadius.circular(5),
//                 //     isSelected: isSelected,
//                 //   ),
//                 // ),
//
//                 SizedBox(height: 25),
//                 Text('Sub Task',
//                     style: TextStyle(
//                         fontSize: 25,
//                         color: Colors.teal,
//                         fontWeight: FontWeight.bold)),
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
import
'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

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
  // String _selection;

  List<bool> isSelected = [true, false];

  TextEditingController name = TextEditingController();
  TextEditingController note = TextEditingController();

  // CollectionReference ref = Firestore.instance.collection('notes');

  //TaskStatus selectedStatus;



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
              // ref.add({
              //   'name': name.text,
              //   'note': note.text,
              //   'category': _selection.toString(),
              //   'taskstatus': taskVal,
              // }).whenComplete(() => Navigator.pop(context))
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
                        fontSize: 25,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold)),
                Divider(
                  color: Colors.teal,
                ),
                SizedBox(height: 15),
                _buildName(),
                SizedBox(height: 15),
                _buildNote(),
                SizedBox(height: 15),
                // SizedBox(height: 5),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: <Widget>[
                //     Radio(
                //       value: 1,
                //       groupValue: _myTaskstatus,
                //       onChanged: _handleTaskStatus,
                //       activeColor: Color(0xff4158ba),
                //     ),
                //     Text(
                //       'Completed',
                //       style: TextStyle(fontSize: 16.0),
                //     ),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: <Widget>[
                //     Radio(
                //       value: 2,
                //       groupValue: _myTaskstatus,
                //       onChanged: _handleTaskStatus,
                //       activeColor: Color(0xfffb537f),
                //     ),
                //     Text(
                //       'Pending',
                //       style: TextStyle(
                //         fontSize: 16.0,
                //       ),
                //     ),
                //   ],
                // ),
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
                Text(
                  'Task Status',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  child: ToggleButtons(

                    isSelected: isSelected,
                    selectedColor: Colors.white,
                    color: Colors.black,
                    fillColor: Colors.teal.shade500,
                    renderBorder: false,
                    //splashColor: Colors.red,
                    highlightColor: Colors.teal.shade300,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text('Completed', style: TextStyle(fontSize: 18)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text('Pending', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                    onPressed: (int newIndex) {
                      setState(() {
                        for (int index = 0; index < isSelected.length; index++) {
                          if (index == newIndex) {
                            isSelected[index] = true;
                          } else {
                            isSelected[index] = false;
                          }
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: 25),



                Text(
                    'Sub Task',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold)
                ),
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
}


