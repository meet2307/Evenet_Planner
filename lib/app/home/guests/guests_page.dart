import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/app/home/guests/edit_guest_page.dart';
import 'package:login_screen/app/home/guests/guest_list_tile.dart';
// import 'file:///D:/Study/Android%20Studio%20Projects/login_screen/lib/components/list_items_builder.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/app/home/models/guest.dart';
import 'package:login_screen/components/list_items_builder.dart';
import 'package:login_screen/components/show_exception_alert_dialog.dart';
import 'package:login_screen/services/database.dart';
import 'package:provider/provider.dart';

class GuestsPage extends StatelessWidget {
  const GuestsPage({@required this.database, @required this.event});
  final Database database;
  final Event event;

  static Future<void> show({BuildContext context, Event event}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => GuestsPage(database: database, event: event),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Guest guest) async {
    try {
      await database.deleteGuest(event, guest);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event> (
        stream: database.eventStream(eventId: event.id),
        builder: (context, snapshot) {
          final event = snapshot.data;
          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Scaffold(
              appBar: AppBar(
                title: Text('Guests'),
                actions: <Widget>[
                  // FlatButton(
                  //   child: Text(
                  //     'Logout',
                  //     style: TextStyle(
                  //       fontSize: 18.0,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   onPressed: () => _confirmSignOut(context),
                  // ),
                ],
              ),
              body: _buildContents(context, event),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => EditGuestPage.show(
                  context: context,
                  database: database,
                  event: event,
                ),
              ),
            ),
          );
        });
  }

  Widget _buildContents(BuildContext context, Event event) {
    return StreamBuilder<List<Guest>>(
      stream: database.guestsStream(eventId: event.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<Guest>(
          snapshot: snapshot,
          itemBuilder: (context, guest) => Dismissible(
            key: Key('guest-${guest.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, guest),
            child: GuestListTile(
              guest: guest,
              onTap: () => EditGuestPage.show(
                context: context,
                database: database,
                event: event,
                guest: guest,
              ),
            ),
          ),
        );
      },
    );
  }
}
