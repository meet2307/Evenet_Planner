import 'package:event_manager_app/app/home/models/budget.dart';
import 'package:event_manager_app/app/home/models/event.dart';
import 'package:event_manager_app/app/home/models/guest.dart';
import 'package:event_manager_app/app/home/models/task.dart';
import 'package:event_manager_app/app/home/models/vendors.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {Key key,
      this.event,
      this.onTap,
      this.budget,
      this.guest,
      this.task,
      this.vendor})
      : super(key: key);
  final Event event;
  final Budget budget;
  final Guest guest;
  final Task task;
  final Vendor vendor;
  final VoidCallback onTap;
  // final VoidCallback onLongTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: event != null
          ? Text(event.name)
          : guest != null
              ? Text(guest.name)
              : task != null
                  ? Text(task.name)
                  : budget != null
                      ? Text(budget.name)
                      : vendor != null
                          ? Text(vendor.name)
                          : null,
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
      // onLongPress: onLongTap,
    );
  }
}
