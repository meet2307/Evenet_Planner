import 'package:meta/meta.dart';

class Vendor {
  Vendor({
    @required this.id,
    @required this.name,
    @required this.category,
    @required this.note,
    @required this.estimated_amount,
    @required this.phone,
    @required this.emailid,
    @required this.website,
    @required this.address,
  });
  final String id;
  final String name;
  final String category;
  final String note;
  final int estimated_amount;
  final String phone;
  final String emailid;
  final String website;
  final String address;

  factory Vendor.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String category = data['category'];
    final String note = data['note'];
    final int estimated_amount = data['estimated_amount'];
    final String phone = data['phone'];
    final String emailid = data['emailid'];
    final String website = data['website'];
    final String address = data['address'];
    return Vendor(
      id: documentId,
      name: name,
      category: category,
      note: note,
      estimated_amount: estimated_amount,
      phone:phone,
      emailid: emailid,
      website: website,
      address:address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'note': note,
      'estimated_amount': estimated_amount,
      'phone': phone,
      'emailid': emailid,
      'website': website,
      'address': address,
    };
  }
}