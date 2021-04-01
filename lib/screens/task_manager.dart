// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:login_screen/screens/from_screen.dart';
// import 'edit_task.dart';
//
// class TaskManager extends StatefulWidget {
//   @override
//   _TaskManagerState createState() => _TaskManagerState();
// }
//
// class _TaskManagerState extends State<TaskManager> {
//
//   final ref = Firestore.instance.collection('notes');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task List'),
//         backgroundColor: Colors.teal,
//         elevation: 4.0,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.search,
//             ),
//             onPressed: () => {},
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.filter_list,
//             ),
//             onPressed: () => {},
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.more_vert,
//             ),
//             onPressed: () => {},
//           ),
//         ],
//         leading: Icon(Icons.arrow_back_ios),
//       ),
//       body: StreamBuilder(
//         stream: ref.snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           return GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//             itemCount: snapshot.hasData ? snapshot.data.documents.length : 0,
//             itemBuilder: (_, index) {
//               return GestureDetector(
//                 onTap: (){
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => EditTask(docTOedit: snapshot.data.documents[index],)),
//                   );
//                 },
//                 child: Container(
//                   margin: EdgeInsets.all(17),
//                   height: 150,
//                   color: Colors.grey[200],
//                   child: Column(
//                     children: [
//                       Text(snapshot.data.documents[index].data['name']),
//                       Text(snapshot.data.documents[index].data['note']),
//                       Text(snapshot.data.documents[index].data['category']),
//                       Text(snapshot.data.documents[index].data['taskstatus']),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//       ),
//
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => FormScreen()),
//           );
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.teal,
//       ),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
//
//
//
//
