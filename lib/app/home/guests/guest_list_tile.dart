import 'package:flutter/material.dart';
import 'package:login_screen/app/home/models/guest.dart';

class GuestListTile extends StatelessWidget {
  const GuestListTile({Key key, @required this.guest, this.onTap}) : super(key: key);
  final Guest guest;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(guest.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
