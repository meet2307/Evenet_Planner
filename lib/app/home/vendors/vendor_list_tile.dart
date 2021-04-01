import 'package:flutter/material.dart';
import 'package:login_screen/app/home/models/vendors.dart';

class VendorListTile extends StatelessWidget {
  const VendorListTile({Key key, @required this.vendor, this.onTap}) : super(key: key);
  final Vendor vendor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(vendor.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
