import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_manager_app/app/Event/edit_event_page.dart';
import 'package:event_manager_app/app/home/home_page.dart';
import 'package:event_manager_app/app/home/models/event.dart';
import 'package:event_manager_app/components/PDF.dart';
import 'package:event_manager_app/components/custom_list_tile.dart';
import 'package:event_manager_app/components/gradient_appbar.dart';
import 'package:event_manager_app/components/gradient_floating_add_button.dart';
import 'package:event_manager_app/components/list_items_builder.dart';
import 'package:event_manager_app/components/show_alert_dialog.dart';
import 'package:event_manager_app/components/show_exception_alert_dialog.dart';
import 'package:event_manager_app/constants.dart';
import 'package:event_manager_app/services/auth.dart';
import 'package:event_manager_app/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key key, this.dataBase, this.uid}) : super(key: key);
  final String uid;
  final Database dataBase;

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  TextEditingController searchController = TextEditingController();
  bool searchState = false;
  String _selection;
  String _browserUrl =
      "https://mahirshekh.blogspot.com/2021/03/event-planner-application-in-flutter.html";

  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'mahirshaikh932002@gmail.com',
      queryParameters: {'subject': 'Feedback'});

  void _launchBrowserURL() async {
    await canLaunch(_browserUrl)
        ? await launch(_browserUrl)
        : throw 'Could not launch $_browserUrl';
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _delete(BuildContext context, Event event) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteEvent(event);
      var id = event.id;
      //This below line is for deleting record which i stored in places collection for Conflicting Event.
      await FirebaseFirestore.instance.doc('places/$id').delete();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, Event event) async {
    final didRequestDelete = await showAlertDialog(
      context,
      title: 'Delete',
      content: 'Are you sure that you want to delete?',
      cancelActionText: 'No',
      defaultActionText: 'Yes',
    );
    if (didRequestDelete == true) {
      _delete(context, event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: !searchState
            ? Text('Events')
            : TextField(
                decoration: InputDecoration(
                  icon: IconButton(
                    icon: Icon(
                      Icons.arrow_back_sharp,
                      color: Colors.white,
                    ),
                    tooltip: 'Back',
                    onPressed: () {
                      setState(() {
                        searchState = !searchState;
                        searchController.clear();
                      });
                    },
                  ),
                  hintText: " Search Here.",
                  hintStyle: TextStyle(color: Colors.white),
                ),
                controller: searchController,
              ),
        elevation: 10.0,
        flexibleSpace:
            GradientAppbar(start: Color(0xFF6448FE), end: Color(0xFF5FC6FF)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: !searchState
                ? IconButton(
                    icon: Icon(
                      Icons.search,
                    ),
                    tooltip: 'Search',
                    onPressed: () {
                      setState(() {
                        searchState = !searchState;
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    tooltip: 'Cancel',
                    onPressed: () {
                      setState(() {
                        searchState = !searchState;
                        searchState = !searchState;
                      });
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: !searchState
                ? PopupMenuButton<String>(
                    icon: Icon(Icons.sort_rounded),
                    onSelected: (String result) {
                      setState(() {
                        _selection = result;
                      });
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: "ascending_name",
                        child: Text('Ascending By Name'),
                      ),
                      const PopupMenuItem<String>(
                        value: "descending_name",
                        child: Text('Descending By Name'),
                      ),
                      const PopupMenuItem<String>(
                        value: "default",
                        child: Text('Default'),
                      ),
                    ],
                  )
                : null,
          ),
        ],
      ),
      drawer: !searchState
          ? Drawer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[Color(0xFF6448FE), Color(0xFF5FC6FF)],
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: <Color>[Color(0xFF6448FE), Color(0xFF5FC6FF)],
                        ),
                      ),
                      accountName: new Text(auth.currentUser.displayName != null
                          ? auth.currentUser.displayName
                          : ''),
                      accountEmail: new Text(auth.currentUser.email),
                      currentAccountPicture: new CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue,
                        backgroundImage: auth.currentUser.photoURL != null
                            ? NetworkImage(auth.currentUser.photoURL)
                            : null,
                        child: auth.currentUser.photoURL == null
                            ? Icon(Icons.camera_alt, size: 50)
                            : null,
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.info_outlined,
                        color: Colors.white,
                      ),
                      title: Text(
                        'For More Info.',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: _launchBrowserURL,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.feedback_outlined,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Feedback',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () => launch(_emailLaunchUri.toString()),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        _confirmSignOut(context);
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: (searchState)
          ? _buildSearchContents(context)
          : (_selection == "ascending_name")
              ? _buildContents(context, "ascending_name")
              : (_selection == "descending_name")
                  ? _buildContents(context, "descending_name")
                  : (_selection == "default")
                      ? _buildContents(context, "default")
                      : _buildContents(context, "default"),
      floatingActionButton: FloatingActionButton(
          child: GradientFloatingAddButton(
              start: Color(0xFF6448FE),
              end: Color(0xFF5FC6FF),
              searchState: searchState),
          onPressed: () => !searchState
              ? EditEvent.show(
                  context,
                  database: Provider.of<Database>(context, listen: false),
                )
              : setState(() {
                  searchState = !searchState; //searchState = !searchState;
                  searchController.clear();
                })
          //onPressed: () => CreateEvent.show(context, database:database)
          ),
    );
  }

  Widget _buildContents(BuildContext context, String action) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Event>>(
      stream: database.eventsStream(order: action),
      builder: (context, snapshot) {
        return ListItemsBuilder<Event>(
          snapshot: snapshot,
          itemBuilder: (context, event) => Slidable(
            key: Key('event-${event.id}'),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                caption: 'View',
                color: kDeleteColor,
                icon: Icons.picture_as_pdf,
                onTap: () => PDF.show(
                  context,
                  database: database,
                  event: event,
                  uid: widget.uid,
                ),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: kDeleteColor,
                icon: Icons.delete,
                onTap: () => _confirmDelete(context, event),
              ),
              IconSlideAction(
                caption: 'Edit',
                color: kEditColor,
                icon: Icons.edit,
                onTap: () => EditEvent.show(
                  context,
                  database: database,
                  event: event,
                ),
              ),
            ],
            child: CustomListTile(
              event: event,
              onTap: () => HomePage.show(context, event),
              // onLongTap: showDialogFunc(context, event),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Event>>(
      stream: database.queryEventStream(eventName: searchController.text),
      builder: (context, snapshot) {
        return ListItemsBuilder<Event>(
          snapshot: snapshot,
          itemBuilder: (context, event) => Slidable(
            key: Key('event-${event.id}'),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                  caption: 'View',
                  color: kDeleteColor,
                  icon: Icons.picture_as_pdf,
                  onTap: () => {
                        PDF.show(
                          context,
                          database: database,
                          event: event,
                        ),
                      }),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: kDeleteColor,
                icon: Icons.delete,
                onTap: () => _confirmDelete(context, event),
              ),
              IconSlideAction(
                caption: 'Edit',
                color: kEditColor,
                icon: Icons.edit,
                onTap: () => EditEvent.show(
                  context,
                  database: database,
                  event: event,
                ),
              ),
            ],
            child: CustomListTile(
              event: event,
              onTap: () => HomePage.show(context, event),
              // onLongTap: showDialogFunc(context, event),
            ),
          ),
        );
      },
    );
  }

  // showDialogFunc(BuildContext context, Event event) {
  //   final String name = event.name;
  //   final String place = event.place;
  //   final String note = event.comment;
  //   final int budget = event.budget;
  //   final start = event.start;
  //   final DateTime date = DateTime(start.year, start.month, start.day);
  //   final TimeOfDay time = TimeOfDay.fromDateTime(start);
  //   Size size = MediaQuery.of(context).size;
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Center(
  //         child: Material(
  //           type: MaterialType.transparency,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10),
  //               color: Colors.white,
  //             ),
  //             padding: EdgeInsets.all(15),
  //             height: size.height * 0.6,
  //             width: size.width * 0.8,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: <Widget>[
  //                 Text(
  //                   "Event Details ",
  //                   style: TextStyle(
  //                     fontSize: 30,
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 SizedBox(height: 10),
  //                 CutomeTextWidget(title: "Name : $name"),
  //                 SizedBox(height: 10),
  //                 CutomeTextWidget(title: "Place : $place"),
  //                 SizedBox(height: 10),
  //                 CutomeTextWidget(title: "Date : $date"),
  //                 SizedBox(height: 10),
  //                 CutomeTextWidget(title: "Time : $time"),
  //                 SizedBox(height: 10),
  //                 CutomeTextWidget(title: "Budget : $budget"),
  //                 SizedBox(height: 10),
  //                 CutomeTextWidget(title: "Note : $note"),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
