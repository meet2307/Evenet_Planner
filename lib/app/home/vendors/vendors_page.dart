import 'package:event_manager_app/app/home/models/event.dart';
import 'package:event_manager_app/app/home/models/vendors.dart';
import 'package:event_manager_app/app/home/vendors/edit_vendor_page.dart';
import 'package:event_manager_app/components/custom_list_tile.dart';
import 'package:event_manager_app/components/custome_text_for_popup.dart';
import 'package:event_manager_app/components/gradient_appbar.dart';
import 'package:event_manager_app/components/gradient_floating_add_button.dart';
import 'package:event_manager_app/components/list_items_builder.dart';
import 'package:event_manager_app/components/show_alert_dialog.dart';
import 'package:event_manager_app/components/show_exception_alert_dialog.dart';
import 'package:event_manager_app/constants.dart';
import 'package:event_manager_app/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorsPage extends StatefulWidget {
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

  @override
  _VendorsPageState createState() => _VendorsPageState();
}

class _VendorsPageState extends State<VendorsPage> {
  TextEditingController searchController = TextEditingController();
  bool searchState = false;
  String _selection;

  Future<void> _confirmDelete(BuildContext context, Vendor vendor) async {
    final didRequestDelete = await showAlertDialog(
      context,
      title: 'Delete',
      content: 'Are you sure that you want to delete?',
      cancelActionText: 'No',
      defaultActionText: 'Yes',
    );
    if (didRequestDelete == true) {
      _delete(context, vendor);
    }
  }

  Future<void> _delete(BuildContext context, Vendor vendor) async {
    try {
      await widget.database.deleteVendor(widget.event, vendor);
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
        stream: widget.database.eventStream(eventId: widget.event.id),
        builder: (context, snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();
          final event = snapshot.data;
          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Scaffold(
              appBar: AppBar(
                title: !searchState
                    ? Text('Vendors')
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
                flexibleSpace: GradientAppbar(
                    start: Color(0xFFFFA738), end: Color(0xFFFFE130)),
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
              body: (searchState)
                  ? _buildSearchContents(context, event)
                  : (_selection == "ascending_name")
                      ? _buildContents(context, event, "ascending_name")
                      : (_selection == "descending_name")
                          ? _buildContents(context, event, "descending_name")
                          : (_selection == "default")
                              ? _buildContents(context, event, "default")
                              : _buildContents(context, event, "default"),
              floatingActionButton: FloatingActionButton(
                child: GradientFloatingAddButton(
                    start: Color(0xFFFFA738),
                    end: Color(0xFFFFE130),
                    searchState: searchState),
                onPressed: () => !searchState
                    ? EditVendorPage.show(
                        context: context,
                        database: widget.database,
                        event: event,
                      )
                    : setState(() {
                        searchState = !searchState;
                        searchController.clear();
                      }),
              ),
            ),
          );
        });
  }

  Widget _buildContents(BuildContext context, Event event, String action) {
    return StreamBuilder<List<Vendor>>(
      stream: widget.database.vendorsStream(eventId: event.id, order: action),
      builder: (context, snapshot) {
        return ListItemsBuilder<Vendor>(
          snapshot: snapshot,
          itemBuilder: (context, vendor) => Slidable(
            key: Key('vendor-${vendor.id}'),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: kDeleteColor,
                icon: Icons.delete,
                onTap: () => _confirmDelete(context, vendor),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                color: kEditColor,
                icon: Icons.edit,
                onTap: () => EditVendorPage.show(
                  context: context,
                  database: widget.database,
                  event: event,
                  vendor: vendor,
                ),
              ),
            ],
            child: CustomListTile(
                vendor: vendor, onTap: () => showDialogFunc(context, vendor)),
          ),
        );
      },
    );
  }

  Widget _buildSearchContents(BuildContext context, Event event) {
    return StreamBuilder<List<Vendor>>(
      stream: widget.database.queryVendorsStream(
          eventId: event.id, vendorName: searchController.text),
      builder: (context, snapshot) {
        return ListItemsBuilder<Vendor>(
          snapshot: snapshot,
          itemBuilder: (context, vendor) => Slidable(
            key: Key('vendor-${vendor.id}'),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: kDeleteColor,
                icon: Icons.delete,
                onTap: () => _confirmDelete(context, vendor),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Edit',
                color: kEditColor,
                icon: Icons.edit,
                onTap: () => EditVendorPage.show(
                  context: context,
                  database: widget.database,
                  event: event,
                  vendor: vendor,
                ),
              ),
            ],
            child: CustomListTile(
              vendor: vendor,
              onTap: () => EditVendorPage.show(
                context: context,
                database: widget.database,
                event: event,
                vendor: vendor,
              ),
            ),
          ),
        );
      },
    );
  }

  showDialogFunc(BuildContext context, Vendor vendor) {
    final String name = vendor.name;
    final String category = vendor.category;
    final String note = vendor.note;
    final int estimated_amount = vendor.estimated_amount;
    final String phone = vendor.phone;
    final String emailid = vendor.emailid;
    final String address = vendor.address;
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Vendor Details ",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    CutomeTextWidget(title: "Name : $name"),
                    SizedBox(height: 10),
                    CutomeTextWidget(title: "Category : $category"),
                    SizedBox(height: 10),
                    CutomeTextWidget(
                        title: "Estimated Amount : $estimated_amount"),
                    SizedBox(height: 10),
                    CutomeTextWidget(title: "Phone : $phone"),
                    SizedBox(height: 10),
                    CutomeTextWidget(title: "Email-Id : $emailid"),
                    SizedBox(height: 10),
                    CutomeTextWidget(title: "Address : $address"),
                    SizedBox(height: 10),
                    CutomeTextWidget(title: "Note : $note"),
                    SizedBox(
                      height: size.height*0.02,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () => _makePhoneCall('tel:$phone'),
                          child: Text(
                            "Call",
                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),
                          ),
                        ),
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Ok",
                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
