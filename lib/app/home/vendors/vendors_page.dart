import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/app/home/models/vendors.dart';
import 'package:login_screen/app/home/vendors/edit_vendor_page.dart';
import 'package:login_screen/app/home/vendors/vendor_list_tile.dart';
import 'package:login_screen/components/list_items_builder.dart';
import 'package:login_screen/components/show_exception_alert_dialog.dart';
import 'package:login_screen/services/database.dart';
import 'package:provider/provider.dart';

class VendorsPage extends StatelessWidget {
  const VendorsPage({@required this.database, @required this.event});
  final Database database;
  final Event event;

  static Future<void> show(BuildContext context, Event event) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => VendorsPage(database: database, event: event),
      ),
    );
  }

  // Future<void> _signOut(BuildContext context) async {
  //   try {
  //     final auth = Provider.of<AuthBase>(context, listen: false);
  //     await auth.signOut();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
  //
  // Future<void> _confirmSignOut(BuildContext context) async {
  //   final didRequestSignOut = await showAlertDialog(
  //     context,
  //     title: 'Logout',
  //     content: 'Are you sure that you want to logout?',
  //     cancelActionText: 'Cancel',
  //     defaultActionText: 'Logout',
  //   );
  //   if (didRequestSignOut == true) {
  //     _signOut(context);
  //   }
  // }

  Future<void> _delete(BuildContext context, Vendor vendor) async {
    try {
      await database.deleteVendor(event, vendor);
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
    return StreamBuilder<Event>(
        stream: database.eventStream(eventId: event.id),
        builder: (context, snapshot) {
          final event = snapshot.data;
          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Scaffold(
              appBar: AppBar(
                title: Text('Vendors'),
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
                onPressed: () => EditVendorPage.show(
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
    return StreamBuilder<List<Vendor>>(
      stream: database.vendorsStream(eventId: event.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<Vendor>(
          snapshot: snapshot,
          itemBuilder: (context, vendor) => Dismissible(
            key: Key('vendor-${vendor.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, vendor),
            child: VendorListTile(
              vendor: vendor,
              onTap: () => EditVendorPage.show(
                context: context,
                database: database,
                event: event,
                vendor: vendor,
              ),
            ),
          ),
        );
      },
    );
  }
}
